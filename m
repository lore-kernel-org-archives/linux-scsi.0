From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0.09
Date: Fri, 04 Apr 2003 15:51:50 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E8D1D76.7050203@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:1038 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263525AbTDDGGK (for <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Apr 2003 01:06:10 -0500
Received: from torque.net (d-242-119.stlucia.uq.net.au [203.101.242.119])
	by bunyip.cc.uq.edu.au (8.12.9/8.12.9) with ESMTP id h346HWGW006162
	for <linux-scsi@vger.kernel.org>; Fri, 4 Apr 2003 16:17:36 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lsscsi is a utility the uses sysfs in kernels >= lk 2.5.50
to list information about all SCSI devices (including devices
that use the SCSI stack such as USB mass storage devices)
and SCSI hosts. Both a compact format (default), one line
per device, and a "classic" format (like the output of
'cat /proc/scsi/scsi') are supported for devices.

Version 0.09 is available at
http://www.torque.net/scsi/lsscsi.html

This version fixes a sorting problem with devices so they
noq appear in ascending "hcil" order. GPL and copyright notice
added to the source. Proper host (HBA) listing awaits further
kernel changes in that area.

Doug Gilbert


