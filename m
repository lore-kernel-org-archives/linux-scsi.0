From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0-12 released
Date: Sun, 09 May 2004 11:57:03 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <409D8FEF.40000@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:27152 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264251AbUEICI5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 May 2004 22:08:57 -0400
Received: from torque.net (d-232-249.stlucia.uq.net.au [203.101.232.249])
	by bunyip.cc.uq.edu.au (8.12.10/8.12.10) with ESMTP id i4928qL6009234
	for <linux-scsi@vger.kernel.org>; Sun, 9 May 2004 12:08:54 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lsscsi is a utility the uses sysfs in linux 2.6 series kernels
to list information about all SCSI devices (including devices
that use the SCSI stack such as USB mass storage devices)
and SCSI hosts. Both a compact format (default) which is one line
per device and a "classic" format (like the output of
'cat /proc/scsi/scsi') are supported for SCSI devices:

$ lsscsi
[0:0:0:0]    disk    Linux    scsi_debug       0004  /dev/sda
[1:0:6:0]    tape    SONY     SDT-7000         0192  /dev/st0

$ lsscsi --classic
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: Linux    Model: scsi_debug       Rev: 0004
   Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi1 Channel: 00 Id: 06 Lun: 00
   Vendor: SONY     Model: SDT-7000         Rev: 0192
   Type:   Sequential-Access                ANSI SCSI revision: 02

Version 0.12 is available at
http://www.torque.net/scsi/lsscsi.html

This version should match lk 2.6.6 assuming there are no major
changes between now and its release.


lsscsi does not currently use libsysfs. The last time I looked,
libsysfs sorts directory entries but does not give the user any
control over the sort order (lsscsi sort by tuples which have
numeric components).

Doug Gilbert


