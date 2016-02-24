From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] sdparm 1.10 available
Date: Tue, 23 Feb 2016 19:20:43 -0500
Message-ID: <56CCF75B.8030105@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Tomas Fasth <tomfa@debian.org>, Martin Pitt <mpitt@debian.org>, David Sommerseth <davids@redhat.com>, Hannes Reinecke <hare@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>, delphij@delphij.net
List-Id: linux-scsi@vger.kernel.org

sdparm is a command line utility designed to get and set SCSI device
parameters (cf hdparm for ATA disks). The parameters are held in
mode pages. Apart from SCSI devices (e.g. disks, tapes and enclosures)
sdparm can be used on any device that uses a SCSI command set. sdparm
also can decode VPD pages including the device identification page.
Commands to start and stop the media; load and unload removable media
and some other housekeeping functions are supported. sdparm supports
both the Linux kernel 2.6, 3 and 4 series with ports to FreeBSD,
Solaris, Tru64 and Windows.

The version tracks changes in draft standards from
www.t10.org since December 2014.

For more information and downloads see:
     http://sg.danny.cz/sg/sdparm.html

ChangeLog  for sdparm-1.10 [20160222] [svn: r279]
   - add --inhex=FN option for decoding without device present,
     FN is interpreted as response to mode sense(10) command
   - add --raw option to interpret FN as binary (def: ASCII hex)
   - add --pdt=PDT option for use with --inhex=FN
   - --quiet used twice hides changeable, default + saved
   - add IO advice hints grouping mode page (sbc4r06, 8)
   - add Unit serial number VPD page specific sanity check
   - add NO_PI_CHK to Supported block lengths and protection
     types VPD page
   - add Background operation control mpage (sbc4r07)
   - Read-write error recovery mpage: add Misaligned writes
     reporting field (MWR)
   - sync tape mpages with ssc5r02
   - add Block limits extension VPD page
   - add Device constituents VPD page
   - add LB protection VPD page (ssc5r02a)
   - LB provisioning VPD page: expand LBPRZ, add Minimum and
     Threshold percentage fields
   - device identification VPD page: add decoding for locally
     assigned UUIDs (spc5r08)
   - the --inhex=FN option together with --inquiry decodes
     FN as a single VPD page
   - improve lto5 and lto6 vendor mpage support
   - sync to spc5r08 and sbc4r10
   - add SAS G5 (22.5 Gbps) settings (spl4r06)
   - point svn:externals to rev 663 of sg3_utils
   - upgrade automake to version 1.15 (U15.10)
   - autogen.sh: upgrade to buildconf 20091223 version

ChangeLog for sdparm-1.09 [20141226] [svn: r257]
....


Doug Gilbert
