From: Brian King <brking@us.ibm.com>
Subject: [RFC] IBM Power RAID driver (ipr) #2
Date: Fri, 23 Jan 2004 15:48:13 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4011969D.3070703@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:4009 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266696AbUAWVsR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2004 16:48:17 -0500
Received: from northrelay04.pok.ibm.com (northrelay04.pok.ibm.com [9.56.224.206])
	by e3.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id i0NLmFcg639882
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2004 16:48:16 -0500
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i0NLmF2B105270
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2004 16:48:15 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is the second

Here is the latest version of the LLD for the IBM Power RAID family of
adapters. This includes several IBM iSeries and pSeries SCSI adapters.
Thanks to everyone who provided comments on the first round.


Major changes include:

1. Complete removal of the ipr char device.
2. All RAID devices now show up to the midlayer as sg devices.
3. Adapter also shows up as an sg device.
4. Dump ioctl is now a binary sysfs file
5. Get trace ioctl is now a binary sysfs file
6. Microcode download is now done using request_firmware and a sysfs
file to initiate it.
7. Reordered code to reduce forward declarations and improve readability.
8. Dump and trace is now a kernel config option
9. Device attributes to adjust queue_depth and enable tcqing.


The driver can be found at:

http://www-124.ibm.com/storageio/ipr/patch-2.6.1-ipr-2.0.0-2.gz

it also requires the following patch, which I submitted this week:

http://www-124.ibm.com/storageio/ipr/patch-2.6.1-array_controller.gz


Thanks


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

