
out = ob_render("~/log/2018/12/nicotine.sdf")
nic = grImport2::readPicture(out$created)
grid.newpage()
grImport2::grid.picture(nic)
