From: "kernel.majianpeng" <kernel.majianpeng@gmail.com>
Subject: sata disk model/firmware length smaller
Date: Thu, 6 Jan 2011 15:38:05 +0800
Message-ID: <201101061538027183872@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46764 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1AFHhO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2011 02:37:14 -0500
Received: by gyb11 with SMTP id 11so6051942gyb.19
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jan 2011 23:37:14 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


At present,I using WD SATA disk:
[root@kedacom device]# smartctl -i /dev/sdo
smartctl version 5.38 [x86_64-redhat-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/
=== START OF INFORMATION SECTION ===
Device Model:     WDC WD2003FYYS-02W0B0
Serial Number:    WD-WMAY00749168
Firmware Version: 01.01D01
User Capacity:    2,000,398,934,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Thu Jan  6 15:12:37 2011 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
[root@kedacom device]# cat /sys/block/sdo/device/rev 
01.0
[root@kedacom device]# cat /sys/block/sdo/device/model 
WDC WD2003FYYS-0
I read ATA spec7, The INQUERY DEVICE command return valued:
Firmware revision 8byte
Model Number 40byte

This may be a bug?
2011-01-06 



kernel.majianpeng 

