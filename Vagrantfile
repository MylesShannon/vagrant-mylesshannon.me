Vagrant::configure("2") do |config|

    config.vm.synced_folder ".", "/vagrant", type: "rsync",
    rsync__exclude: [".git/"]

    config.vm.provider :virtualbox do |vbox, override|
      override.vm.box = "ubuntu/trusty64"
      override.vm.network "forwarded_port", guest: 80, host: 8000
      override.vm.network "forwarded_port", guest: 81, host: 8001
      override.vm.provision "shell", path: "vbox-provision.sh", privileged: false
      override.vm.synced_folder "../php.mylesshannon.me", "/vagrant/laravel", type: "rsync",
        owner: "vagrant",
        group: "www-data",
        mount_options: ["dmode=775,fmode=775"],
        rsync__exclude: [".git/"]
      override.vm.synced_folder "../rails.mylesshannon.me", "/vagrant/rails", type: "rsync",
        owner: "vagrant",
        group: "www-data",
        mount_options: ["dmode=775,fmode=775"],
        rsync__exclude: [".git/"]
    end

    config.vm.provider :aws do |aws, override|
      # static configurations
      aws.keypair_name = "mylesshannon"
      aws.elb = "api-mylesshannon-me"
      aws.security_groups = ["EC2 to ELB"]
      override.ssh.private_key_path = "./mylesshannon.pem"
      # end
      override.vm.box = "dummy"
      aws.region = "us-east-1"
      aws.ami = "ami-2d39803a"
      aws.availability_zone = "us-east-1c"
      aws.instance_type = "t2.micro"
      override.ssh.username = "ubuntu"
      override.vm.provision "shell", path: "aws-provision.sh", privileged: false
      override.vm.synced_folder "../php.mylesshannon.me", "/vagrant/laravel", type: "rsync",
        owner: "ubuntu",
        group: "www-data",
        mount_options: ["dmode=775,fmode=775"],
        rsync__exclude: [".git/"]
      override.vm.synced_folder "../rails.mylesshannon.me", "/vagrant/rails", type: "rsync",
        owner: "ubuntu",
        group: "www-data",
        mount_options: ["dmode=775,fmode=775"],
        rsync__exclude: [".git/"]
    end

end