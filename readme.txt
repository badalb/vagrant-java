Setup Instructions

1. Download and install virtual box and vagrant
	a. follow the link: https://docs.vagrantup.com/v2/getting-started/
    b. [you can follow this video: https://www.youtube.com/watch?v=RhhF8Yh7OnE]
2. Install puppet and librarian puppet
	a. execute debian/mac env specific puppet and librarian puppet file.

3. Add modules in Puppet file [execute sudo librarian-puppet install form Puppetfile directory]

4. Update default.pp file 

5. Vagrant reload --provision from Vagrant file directory

6. To search modules use command sudo puppet module search eclipse