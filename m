From: Douglas Gilbert <dougg@torque.net>
Subject: lsscsi-0.08
Date: Tue, 04 Mar 2003 09:15:00 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E63D3E4.9010908@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (d-242-92.stlucia.uq.net.au [203.101.242.92])
	by bunyip.cc.uq.edu.au (8.12.8/8.12.8) with ESMTP id h23NGUGf014187
	for <linux-scsi@vger.kernel.org>; Tue, 4 Mar 2003 09:16:31 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

lsscsi is a utility the uses sysfs in kernels >= lk 2.5.50
to list information about all SCSI devices (including devices
that use the SCSI stack such as USB mass storage devices)
and SCSI hosts. Both a compact format (default), one line
per device, and a "classic" format (like the output of
'cat /proc/scsi/scsi') are supported for devices.

Version 0.08 is available at
http://www.torque.net/scsi/lsscsi.html

This version starts to add listing support for SCSI hosts
(i.e. instances of scsi_host). This follows on from work
by Christoph Hellwig to transfer procfs information
provided by sg into sysfs in lk 2.5.63 .
The only hosts that I can currently get to appear are those
created by the scsi_debug driver. So the appropriate magic
that the scsi_debug driver does (supplied by Mike Anderson)
either needs to be:
  - placed in all LLDs,
  - or placed in the mid level

Doug Gilbert

