

variable "ami_id" {
    default = "ami-023a307f3d27ea427"
}

variable "instance_type" {
    default = "t2.micro"
}

resource "aws_security_group" "allow_all" {
    name        = "allow_all_traffic"
    description = "Allow all inbound and outbound traffic"

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "kubernetes_master" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    key_name               = "master"
    vpc_security_group_ids = [aws_security_group.allow_all.id]
    tags = {
        Name = "kubernetes_master"
    }
}

resource "aws_instance" "kubernetes_slave" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    key_name               = "master"
    vpc_security_group_ids = [aws_security_group.allow_all.id]
    tags = {
        Name = "kubernetes_slave"
    }
}

resource "aws_instance" "jenkins_master" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    key_name               = "master"
    vpc_security_group_ids = [aws_security_group.allow_all.id]
    tags = {
        Name = "jenkins_master"
    }
}

resource "aws_instance" "jenkins_slave" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    key_name               = "master"
    vpc_security_group_ids = [aws_security_group.allow_all.id]
    tags = {
        Name = "jenkins_slave"
    }
}

resource "aws_instance" "ansible_controller" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    key_name               = "master"
    vpc_security_group_ids = [aws_security_group.allow_all.id]
    tags = {
        Name = "ansible_controller"
    }
    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -yyes
                sudo apt install software-properties-common -y
                sudo add-apt-repository --yes --update ppa:ansible/ansible
                sudo apt update -y
                sudo apt install ansible -y
                ansible --version
                sudo useradd devopsadmin -s /bin/bash -m -d /home/devopsadmin
                su - devopsadmin -c 'ssh-keygen -t ecdsa -b 521 -f ~/.ssh/id_ecdsa -N ""'
                sudo chown -R devopsadmin:devopsadmin /etc/ansible
                EOF     
}
