From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0.10
Date: Tue, 06 May 2003 11:51:34 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB71526.4010806@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:64527 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262234AbTEFBgW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 21:36:22 -0400
Received: from torque.net (d-241-253.stlucia.uq.net.au [203.101.241.253])
	by bunyip.cc.uq.edu.au (8.12.9/8.12.9) with ESMTP id h461mpHO018557
	for <linux-scsi@vger.kernel.org>; Tue, 6 May 2003 11:48:52 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lsscsi is a utility the uses sysfs in kernels >= lk 2.5.50
to list information about all SCSI devices (including devices
that use the SCSI stack such as USB mass storage devices)
and SCSI hosts. Both a compact format (default), one line
per device, and a "classic" format (like the output of
'cat /proc/scsi/scsi') are supported for devices.

Version 0.10 is available at
http://www.torque.net/scsi/lsscsi.html

This version adds host listing ("-H" option) when
used together with Mike Anderson's "scsi host sysfs"
patch set for lk 2.5.69 .

Doug Gilbert

