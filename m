From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] lsscsi 0.25 beta 1, adds --size
Date: Fri, 11 Mar 2011 15:33:16 -0500
Message-ID: <4D7A870C.7040809@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:37281 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab1CKUdU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2011 15:33:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@ORACLE.COM>
Cc: linux-kernel <linux-kernel@vger.kernel.org>

Martin Petersen recently sent me some patches
to add a --size (or '-s') option to lsscsi:

# lsscsi -s
[0:0:0:0]  disk  ATA    INTEL SSD  2CV1 /dev/sda 80.0GB
[10:0:0:0] disk  Linux  scsi_debug 0004 /dev/sdb 1.09TB

Martin and I had several hacks at this. Getting
utilities to work reliably with sysfs across various
kernel versions continues to be a crap shoot. So
I am putting this out as a beta and hoping that
anyone with problems will contact me (or Martin).

Note that this logic decodes /sys/block/sda/size
(for example) so disks that are present but without
a block interface (e.g. physical disks in a RAID)
will not have a size shown ('-' is shown instead).

Version 0.25 beta 1 is available at:
     http://sg.danny.cz/scsi/lsscsi.html
More information can be found on that page including examples
and a Download section for the tarball:
   http://sg.danny.cz/scsi/lsscsi-0.25b1.tgz
There are no debian or redhat packages built for this beta.

Version 0.25 2011/03/04 [svn: r91]
   - add sas_port and fc_remote_ports transport information
   - print enclosure_device entry
   - add '--size' option to show size of disks
   - add '--protmode' option to show protection information mode

Version 0.24 2010/06/12 [svn: r83]
.....


Doug Gilbert
