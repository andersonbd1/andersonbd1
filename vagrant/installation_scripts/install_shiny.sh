# https://www.rstudio.com/products/shiny/download-server/

cat <<EOT >> /usr/lib/R/etc/Rprofile.site
options(download.file.method = "libcurl")

local({
  r <- getOption("repos")
  r["CRAN"] <- "https://cran.rstudio.com/"
  options(repos=r)
})
EOT

sudo su - -c "R -e \"install.packages('shiny')\""
sudo su - -c "R -e \"install.packages('rmarkdown')\""

SS_VERS="shiny-server-1.4.2.786-amd64.deb"
sudo apt-get install gdebi-core
wget https://download3.rstudio.org/ubuntu-12.04/x86_64/${SS_VERS} > ${ID}/${SS_VERS}
sudo gdebi ${ID}/${SS_VERS}
