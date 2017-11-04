PRO dark_script,path

  spawn,'ls '+path+'/n*.fits',list

  bigstr = ['']
  for i = 0,n_elements(list)-1 do begin
     x = mrdfits(list[i],0,header,/silent)
     SAMPMODE = sxpar(header,'SAMPMODE')
     multisam = sxpar(header,'MULTISAM')
     coadd = sxpar(header,'COADDS')
     subc = sxpar(header,'NAXIS1')
     tint = string(sxpar(header,'ITIME'),format="(D10.1)")
     if sampmode eq 2 then multisam = ''
     str = strtrim(subc,2)+','+strtrim(sampmode,2)+' '+strtrim(multisam,2)+','+strtrim(tint,2)+','+strtrim(coadd,2)
     bigstr = [bigstr,str]

  endfor
  shrink,bigstr
  bigstr = bigstr[sort(bigstr)]
  bigstr = bigstr[uniq(bigstr)]
  close,/all
  openw,12,'dark_script'
  printf,12,'shutter close'
  printf,12,'wait4ao off'
  printf,12,'filt jcont'
  printf,12,'object darks'
  for i = 0,n_elements(bigstr)-1 do begin
     print,bigstr[i]
     tmp = strsplit(bigstr[i],',',/extract)
     printf,12,''
     printf,12,'subc '+tmp[0]
     printf,12,'sampmode '+tmp[1]
     printf,12,'tint '+tmp[2]
     printf,12,'coadd '+tmp[3]
     printf,12,'goi 15'

  endfor
  close,/all

  print,string(n_elements(bigstr),format="(I3)")+' total dark types'
  stop


END
