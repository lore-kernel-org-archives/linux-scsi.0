From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0.11
Date: Fri, 09 Jan 2004 17:41:13 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FFE5B19.7050404@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:23566 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S266430AbUAIHnM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jan 2004 02:43:12 -0500
Received: from torque.net (d-240-123.stlucia.uq.net.au [203.101.240.123])
	by bunyip.cc.uq.edu.au (8.12.10/8.12.10) with ESMTP id i097h6ci009661
	for <linux-scsi@vger.kernel.org>; Fri, 9 Jan 2004 17:43:08 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lsscsi is a utility the uses sysfs in the linux 2.6 series kernels
to list information about all SCSI devices (including devices
that use the SCSI stack such as USB mass storage devices)
or all SCSI hosts that are attached to the system. Both a compact
format (default), one line per device, and a "classic" format (like
the output of 'cat /proc/scsi/scsi') are supported for devices.

Version 0.11 is available at
http://www.torque.net/scsi/lsscsi.html

This version has been reworked for lk 2.6.1-rc1 (and later)
since sysfs support for st and sg devices has been (re-)added.

lsscsi does not yet use libsysfs but may well soon. One thing
that lsscsi does that is not yet available in libsysfs is
to sort (and filter) directory entries. This is most likely
not relevant for most libsysfs based applications but is
convenient for those applications that display information
for human consumption.

Doug Gilbert

