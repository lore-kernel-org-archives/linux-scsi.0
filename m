From: Douglas Gilbert <dougg@torque.net>
Subject: [ANNOUNCE] sdparm 0.91
Date: Sat, 07 May 2005 13:36:54 +1000
Message-ID: <427C37D6.3080507@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:22755 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262644AbVEGDkS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2005 23:40:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

sdparm is a command line utility designed to get and set
SCSI disk parameters (cf hdparm for ATA disks). More generally
it gets and sets mode page information on SCSI devices or devices
that use a SCSI command set (e.g. CD/DVD drives (any transport)
and SCSI tape drives). It also can list device identification
descriptors from VPD pages.

For more information and downloads (tarball, rpms and deb
packages) see:
http://www.torque.net/sg/sdparm.html

This utility overlaps in functionality somewhat with
blktool by Jeff Garzik.

sdparm 0.90 was the original version released.
ChangeLog for sdparm-0.91 [20050506]
   - if lk 2.4 detected, map primary SCSI node to sg node for
     ease of use
   - add support for '--inquiry' (VPD pages, defaults to
     device identification)
   - decode format and rigid disk mode pages (sbc2)
     [both pages are obsolete but common]


Doug Gilbert
