resource "local_file" "build_ansible_hosts_file" {
    filename = "../ansible/hosts"
    content = templatefile("templates/hosts",
        {
            host_public = aws_instance.inst.public_ip,
        }
    )
    depends_on = [
        aws_instance.inst,
    ]
}
