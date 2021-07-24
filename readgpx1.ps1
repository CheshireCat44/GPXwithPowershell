# extract data from gpx file

# name of gpx file to be read
$gpxfile = "D:\Docs\PowerShell\gpx\readgpx1.gpx"

# the [xml] "accelerator" causes the content of the file to
# be treated as XML - which GPX is
[xml]$gpxdata = get-content $gpxfile

# tracks are lists of points, so create an empty list object
# make it a [pscustomobject] list because we shall add
# pscustomobject entries later
$trkdata = New-Object 'System.Collections.Generic.List[pscustomobject]'

# the top level object in a GPX file is always 'gpx'
# within the gpx object there are 'trk' objects 
foreach ($trk in $gpxdata.gpx.trk) {
    # get the name of the current trk
    $trkname = $trk.name
    foreach ($trkpt in $trk.trkseg.trkpt) {
        # uncomment the 'write-host' to see the data going through
        # write-host expects strings so
        # the $($trkpt.time) structure tells PS that '$trkpt.time'
        # is the variable as opposed to
        # 'the value of trkpt' folowed by '.time'
        #write-host $trkname,$($trkpt.time), $($trkpt.lat), $($trkpt.lon)
        # the @{} - called a 'splat' in PS creates a hash table
        # this can have any number of elements
        # lists can have elements added easily and efficiently
        $trkdata.Add([pscustomobject]@{
            track=$trkname
            lat=$trkpt.lat
            lon=$trkpt.lon
<#            
            add any other elements required here, e.g.
            ele=$trkpt.ele
#>
        }) 
    }
}

# format-table presents the output easily
# as GPX files can have huge numbers of points
# limit the number of items presented with the
# 'select-object -first 20' clause 
$trkdata | select-object -First 20 | Format-Table

# trkdata now contains the data you need ready to be manipulated
# however you wish, perhaps exported as csv
