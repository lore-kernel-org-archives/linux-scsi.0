From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] sdparm 1.08 available
Date: Sun, 09 Jun 2013 12:26:19 -0400
Message-ID: <51B4ACAB.20605@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:32986 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811Ab3FIQ1Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Jun 2013 12:27:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Tomas Fasth <tomfa@debian.org>, Martin Pitt <mpitt@debian.org>, kumba@gentoo.org, =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>, delphij@delphij.net

sdparm is a command line utility designed to get and set
SCSI device parameters (cf hdparm for ATA disks). The
parameters are held in mode pages. Apart from SCSI devices
(e.g. disks, tapes and enclosures) sdparm can be used on
any device that uses a SCSI command set. Almost all CD/DVD/BD
drives use the SCSI MMC set irrespective of the transport.
sdparm also can decode VPD pages including the device
identification page. Commands to start and stop the media;
load and unload removable media and some other housekeeping
functions are supported. sdparm supports both the Linux
kernel 2.4, 2.6 and 3 series with ports to FreeBSD, Solaris,
Tru64 and Windows.

The version tracks changes in draft standards from
www.t10.org since January 2012.

For more information and downloads see:
     http://sg.danny.cz/sg/sdparm.html

ChangeLog for sdparm-1.08 [20130606] [svn: r215]
   - device id VPD: add protocol specific port identifier
   - control extension mpage: add max sense data length
   - power condition mpage: FIDCPC->CCF_IDLE,
     FSBCPC->CCF_STAND, FSTCPC->CCF_STOPP (spc4r34+)
   - caching mpage: add SYNC_PROG field (sbc3r33)
   - block device characteristics VPD page additions sbc3r34
   - extended inquiry vpd page: add max supported sense data
     length
   - protocol-specific port information VPD page for SAS SSP,
     persistent connection (spl3r2), power disable (spl3r3)
   - allow --readonly with --set= and --clear=
   - add placeholder for third party copy VPD page
   - supply more information if a UA occurs
   - add Makefile so scripts/sas_disk_blink installed
   - scripts/scsi_ch_swp: new, uses sdparm and blockdev
   - ./configure options:
     - change --enable-no-linux-bsg to --disable-linuxbsg
     - add --disable-scsistrings to reduce utility size
       with non-libsgutils build
   - point svn:externals to rev 498 of sg3_utils
     - report sdat_ovfl bit (if set) in sense data
     - sg_pt_linux: expand DID_ (host_byte) codes
       - cope with a transport error plus sense data
       - prefer major() over MAJOR() macro
     - win32: fixes for cygwin version 1.7.17 headers

ChangeLog for sdparm-1.07 [20120121] [svn: r188]
...


Doug Gilbert
