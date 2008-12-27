From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] lsscsi-0.22 released
Date: Fri, 26 Dec 2008 22:29:36 -0500
Message-ID: <4955A120.3060703@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44857 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbYL0D3v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Dec 2008 22:29:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Matt Taggart <taggart@debian.org>

lsscsi is a utility that uses sysfs in linux 2.6 series kernels
to list information about SCSI devices and SCSI hosts. Both a
compact format which is one line per device and a "classic"
format (like the output of 'cat /proc/scsi/scsi') are supported.

Version 0.22 is available at
http://sg.danny.cz/scsi/lsscsi.html
More information can be found on that page including examples
and a Download section for tarballs, rpm and deb packages.

ChangeLog:
Version 0.22 2008/12/26 [svn: r71]
   - add protection information (see CREDITS file)
   - add USB transport type with USB device name
   - add ATA and SATA transport types (crude: by driver name)
Version 0.21 2008/7/10 [svn: r64]
   ....

Example of some new features:
$ lsscsi
[0:0:0:0]    disk    ATA      FUJITSU MHY2160B 0000  /dev/sda
[3:0:0:0]    cd/dvd  MATSHITA DVD/CDRW UJDA775 CB03  /dev/scd0
[5:0:0:0]    disk    USB 2.0  SD/MMC Reader          /dev/sdb
[6:0:0:0]    disk    JetFlash TS2GJFVxx        8.01  /dev/sdc

$ lsscsi -t
[0:0:0:0]    disk    sata:                           /dev/sda
[3:0:0:0]    cd/dvd  ata:                            /dev/scd0
[5:0:0:0]    disk    usb: 7-1:1.0                    /dev/sdb
[6:0:0:0]    disk    usb: 7-2.4:1.0                  /dev/sdc


Doug Gilbert
