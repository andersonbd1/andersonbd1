cp /mydev/andersonbd1/home/.bashrc $HD
cp /mydev/andersonbd1/home/.vimrc $HD

# This is just for show - my "real" tmux scripts are in google drive
# mkdir -p $HD/.tmuxinator
# cp /mydev/andersonbd1/home/.tmuxinator/* $HD/.tmuxinator


cp /google_drive/home_files/.s3cfg $HD
#ln -s /google_drive/home_files/.s3cfg ~/.s3cfg

#cp -R /google_drive/home_files/.tmuxinator $HD
ln -s /google_drive/home_files/.tmuxinator ~/.tmuxinator

cp -R /google_drive/home_files/.ssh $HD

chown -R vagrant /home/vagrant
chmod -R 600 $HD/.ssh/*
