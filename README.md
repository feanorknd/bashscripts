
INSTALL
------------------------------------------------------------------------------------------------------------------------------------------

apt install -y curl

rsync -avE /root/.bashrc /root/.bashrc.original &&
curl -o /root/.bashscripts "https://raw.githubusercontent.com/feanorknd/bashscripts/main/bashscripts" && chmod 0600 /root/.bashscripts &&
curl -o /root/.bashrc "https://raw.githubusercontent.com/feanorknd/bashscripts/main/bashrc.jammy" && chmod 0644 /root/.bashrc &&



UPDATE
------------------------------------------------------------------------------------------------------------------------------------------

Update command:
curl -o /root/.bashscripts "https://raw.githubusercontent.com/feanorknd/bashscripts/main/bashscripts" && chmod 0600 /root/.bashscripts

or just execute alias:
'update-bashscripts'
