From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] sdparm 1.09 available
Date: Sat, 27 Dec 2014 20:19:01 -0500
Message-ID: <549F5A85.8030504@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48817 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbaL1BTP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Dec 2014 20:19:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi development list <linux-scsi@vger.kernel.org>
Cc: Tomas Fasth <tomfa@debian.org>, Martin Pitt <mpitt@debian.org>, David Sommerseth <davids@redhat.com>, Hannes Reinecke <hare@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>, delphij@delphij.net

sdparm is a command line utility designed to get and set
SCSI device parameters (cf hdparm for ATA disks). The
parameters are held in mode pages. Apart from SCSI devices
(e.g. disks, tapes and enclosures) sdparm can be used on
any device that uses a SCSI command set. sdparm also can
decode VPD pages including the device identification page.
Commands to start and stop the media; load and unload
removable media and some other housekeeping functions are
supported. sdparm supports both the Linux kernel 2.6 and 3
series with ports to FreeBSD, Solaris, Tru64 and Windows.

The version tracks changes in draft standards from
www.t10.org since June 2013.

For more information and downloads see:
     http://sg.danny.cz/sg/sdparm.html

ChangeLog for sdparm-1.09 [20141226] [svn: r257]
   - decode Third Party Copy VPD page
   - Supported block lengths and protection types (sbc4r01) +
     Block device characteristics extension VPD pages added
   - zoned block device characterics VPD page added (zbc-r01c)
   - fix manufacturer-assigned serial number VPD page length
   - device id VPD: T10 vendor identification designator clean up
   - block device characteristics VPD: add ZONED (sbc4r04)
   - SAS/SPL disconnect-reconnect mpage: expand
   - SAS protocol specific port mpage: add MAXR field (spl4r01)
   - standard inquiry response (sinq): add LU_CONG
   - change ibm vendor code to lto5 and lto6
   - point svn:externals to rev 620 of sg3_utils
   - upgrade automake to version 1.14.1
   - configure: add --disable-libsgutils so build bypasses that
     library if present
   - win32: some --wscan and compile fixes

ChangeLog for sdparm-1.08 [20130606] [svn: r215]
....


This package may be built to depend on the shared library
produced by the sg3_utils, version 1.40 package (released
20141113). Alternatively this package can be built to
statically include the code it needs from sg3_utils.


Doug Gilbert
