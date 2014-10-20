(* virt-v2v
 * Copyright (C) 2009-2014 Red Hat Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *)

open Printf

open Common_gettext.Gettext
open Common_utils

open Types
open Utils

(* Check the backend is not libvirt.  Works around a libvirt bug
 * (RHBZ#1134592).  This can be removed once the libvirt bug is fixed.
 *)
let error_if_libvirt_backend () =
  let libguestfs_backend = (new Guestfs.guestfs ())#get_backend () in
  if libguestfs_backend = "libvirt" then (
    error (f_"because of libvirt bug https://bugzilla.redhat.com/show_bug.cgi?id=1134592 you must set this environment variable:\n\nexport LIBGUESTFS_BACKEND=direct\n\nand then rerun the virt-v2v command.")
  )

(* xen+ssh URLs use the SSH driver in CURL.  Currently this requires
 * ssh-agent authentication.  Give a clear error if this hasn't been
 * set up (RHBZ#1139973).
 *)
let error_if_no_ssh_agent () =
  try ignore (Sys.getenv "SSH_AUTH_SOCK")
  with Not_found ->
    error (f_"ssh-agent authentication has not been set up ($SSH_AUTH_SOCK is not set).  Please read \"INPUT FROM RHEL 5 XEN\" in the virt-v2v(1) man page.")

(* Superclass. *)
class virtual input_libvirt verbose libvirt_uri guest =
object
  inherit input verbose

  method as_options =
    sprintf "-i libvirt%s %s"
      (match libvirt_uri with
      | None -> ""
      | Some uri -> " -ic " ^ uri)
      guest
end

(* Subclass specialized for handling anything that's *not* VMware vCenter
 * or Xen.
 *)
class input_libvirt_other verbose libvirt_uri guest =
object
  inherit input_libvirt verbose libvirt_uri guest

  method source () =
    if verbose then printf "input_libvirt_other: source()\n%!";

    (* Get the libvirt XML.  This also checks (as a side-effect)
     * that the domain is not running.  (RHBZ#1138586)
     *)
    let xml = Domainxml.dumpxml ?conn:libvirt_uri guest in

    Input_libvirtxml.parse_libvirt_xml ~verbose xml
end

(* Subclass specialized for handling VMware vCenter over https. *)
class input_libvirt_vcenter_https
  verbose libvirt_uri parsed_uri scheme server guest =
object
  inherit input_libvirt verbose libvirt_uri guest

  method source () =
    if verbose then printf "input_libvirt_vcenter_https: source()\n%!";

    error_if_libvirt_backend ();

    (* Get the libvirt XML.  This also checks (as a side-effect)
     * that the domain is not running.  (RHBZ#1138586)
     *)
    let xml = Domainxml.dumpxml ?conn:libvirt_uri guest in
    let { s_disks = disks } as source =
      Input_libvirtxml.parse_libvirt_xml ~verbose xml in

    let mapf = VCenter.map_path_to_uri verbose parsed_uri scheme server in
    let disks = List.map (
      fun ({ s_qemu_uri = uri; s_format = format } as disk) ->
        let uri, format = mapf uri format in
        { disk with s_qemu_uri = uri; s_format = format }
    ) disks in

    { source with s_disks = disks }
end

(* Subclass specialized for handling Xen over SSH. *)
class input_libvirt_xen_ssh
  verbose libvirt_uri parsed_uri scheme server guest =
object
  inherit input_libvirt verbose libvirt_uri guest

  method source () =
    if verbose then printf "input_libvirt_xen_ssh: source()\n%!";

    error_if_libvirt_backend ();
    error_if_no_ssh_agent ();

    (* Get the libvirt XML.  This also checks (as a side-effect)
     * that the domain is not running.  (RHBZ#1138586)
     *)
    let xml = Domainxml.dumpxml ?conn:libvirt_uri guest in
    let { s_disks = disks } as source =
      Input_libvirtxml.parse_libvirt_xml ~verbose xml in

    let mapf = Xen.map_path_to_uri verbose parsed_uri scheme server in
    let disks = List.map (
      fun ({ s_qemu_uri = uri; s_format = format } as disk) ->
        let uri, format = mapf uri format in
        { disk with s_qemu_uri = uri; s_format = format }
    ) disks in

    { source with s_disks = disks }
end

(* Choose the right subclass based on the URI. *)
let input_libvirt verbose libvirt_uri guest =
  match libvirt_uri with
  | None ->
    new input_libvirt_other verbose libvirt_uri guest

  | Some orig_uri ->
    let { Xml.uri_server = server; uri_scheme = scheme } as parsed_uri =
      try Xml.parse_uri orig_uri
      with Invalid_argument msg ->
        error (f_"could not parse '-ic %s'.  Original error message was: %s")
          orig_uri msg in

    match server, scheme with
    | None, _
    | Some "", _                        (* Not a remote URI. *)

    | Some _, None                      (* No scheme? *)
    | Some _, Some "" ->
      new input_libvirt_other verbose libvirt_uri guest

    | Some server, Some ("esx"|"gsx"|"vpx" as scheme) -> (* vCenter over https *)
      new input_libvirt_vcenter_https
        verbose libvirt_uri parsed_uri scheme server guest

    | Some server, Some ("xen+ssh" as scheme) -> (* Xen over SSH *)
      new input_libvirt_xen_ssh
        verbose libvirt_uri parsed_uri scheme server guest

    (* Old virt-v2v also supported qemu+ssh://.  However I am
     * deliberately not supporting this in new virt-v2v.  Don't
     * use virt-v2v if a guest already runs on KVM.
     *)

    | Some _, Some _ ->             (* Unknown remote scheme. *)
      warning ~prog (f_"no support for remote libvirt connections to '-ic %s'.  The conversion may fail when it tries to read the source disks.")
        orig_uri;
      new input_libvirt_other verbose libvirt_uri guest

let () = Modules_list.register_input_module "libvirt"
