#
# /*
#  * Copyright (c) 2022.
#  *
#  *  - All Rights Reserved
#  *  Unauthorized copying of this project, via any medium is strictly prohibited
#  *  Proprietary and confidential
#  *  Written by Kester Riley <kesterriley@hotmail.com>
#  *
#  *  Please refer to the Projects LICENSE file for further details.
#  *
#  */
#

git version || brew install git
mkdir /tmp/mariadbdemo
cd /tmp/mariadbdemo
git clone https://github.com/<REPLACE WITH YOUR GITHUB USER NAME>/terraformDemo.git
git clone https://github.com/<REPLACE WITH YOUR GITHUB USER NAME>/phpAppDocker.git
git clone https://github.com/<REPLACE WITH YOUR GITHUB USER NAME>/mariadbMaxscaleDocker.git
git clone https://github.com/<REPLACE WITH YOUR GITHUB USER NAME>/mariadbServerDocker.git

Now, change in to the cloned directory:

    cd /tmp/mariadbdemo/terraformDemo

And set your GitHub login information.

	git config user.name "<REPLACE WITH YOUR GITHUB USER NAME>"
	git config user.email "<REPLACE WITH YOUR GITHUB EMAIL>"