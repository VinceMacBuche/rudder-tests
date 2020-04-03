-- Functions
let Types = ./types.dhall

let run = \(x : List Text) -> {
        type = "shell"
        ,execute_command = "echo 'vagrant' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
        ,scripts = x
}

let mk_virtualbox_iso : List Text -> Text -> Types.Vagrant_ssh -> Types.Virtualbox_iso =
        \(boot_command : List Text) ->
        \(os_name : Text) ->
        \(vagrant : Types.Vagrant_ssh) ->
        let os = os_name
        let boot_command = boot_command
        let vagrant = vagrant
        let iso = ./iso.dhall
        let virtualbox_iso : Types.Virtualbox_iso =
        {
        type = "virtualbox-iso"
        ,boot_command = boot_command
        ,boot_wait = "10s"
        ,disk_size = "8192"
        ,shutdown_command = "echo 'vagrant'|sudo -S shutdown -P now"
        ,headless = True
        ,http_directory = "http"
        ,guest_additions_path = "VBoxGuestAdditions_{{.Version}}.iso"
        ,virtualbox_version_file = ".vbox_version"
        ,iso_urls = iso.iso_urls
        ,iso_checksum_type = iso.iso_checksum_type
        ,iso_checksum = iso.iso_checksum
        ,guest_os_type = iso.guest_os_type
        ,vm_name = "packer-${os}-amd64"
        ,ssh_username = vagrant.ssh_username
        ,ssh_password = vagrant.ssh_password
        ,ssh_port = vagrant.ssh_port
        ,ssh_wait_timeout = vagrant.ssh_wait_timeout
        }
        in virtualbox_iso


let mk_file_builder : Text -> Text -> Types.File_builder =
    \(content : Text) ->
    \(target : Text) ->
    let content = content
    let target = target
    let file_builder : Types.File_builder =
    {
      type = "file"
    , content = content
    , target = target
    }
    in file_builder

let mk_shell_local : List Text -> Types.Shell_local =
    \(inline : List Text) ->
    let inline = inline
    let shell_local : Types.Shell_local =
    {
      type = "shell_local"
    , inline = inline
    }
    in shell_local

let mk_vagrant_post_processor : Text -> Types.Vagrant_post_processor =
    \(box : Text) ->
    let box = box
    let postproc : Types.Vagrant_post_processor =
    {
      type = "vagrant"
    , output = box
    }
    in postproc

let mk_vagrant : Text -> Types.Vagrant_ssh =
    \(user : Text) ->
    let user = user
    let vagrant : Types.Vagrant_ssh =
    {
      ssh_username = user
      ,ssh_password = user
      ,ssh_port = "22"
      ,ssh_wait_timeout = "1000s"
    }
    in vagrant

in {run = run
   ,mk_virtualbox_iso = mk_virtualbox_iso
   ,mk_file_builder = mk_file_builder
   ,mk_vagrant = mk_vagrant
   ,mk_shell_local = mk_shell_local
   ,mk_vagrant_post_processor = mk_vagrant_post_processor
}