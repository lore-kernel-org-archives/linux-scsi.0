From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 0/7] be2iscsi: Update to 10.2.84.0
Date: Sun, 12 Jan 2014 16:42:21 -0800
Message-ID: <1389573741-3523-8-git-send-email-jayamohan.kallickal@emulex.com>
References: <1389573741-3523-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:56460 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaAMCiX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2014 21:38:23 -0500
Received: by mail-pd0-f175.google.com with SMTP id r10so2833136pdi.20
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2014 18:38:22 -0800 (PST)
In-Reply-To: <1389573741-3523-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

This patchset updates be2iscsi driver to  10.2.84.0
 and contains the following patches based of  scsi.git 
for-next-base
`
 PATCH 0001 - Fix handling MBX completion time out  
 PATCH 0002 - Fix typo in port speed  
 PATCH 0003 - Fix IRQ Affinity Support in driver
 PATCH 0004 - Fix updating statistics in driver 
 PATCH 0005 - Fix DoorBell FOrmat for EQ and CQ 
 PATCH 0006 - Fix Session Cleanup  
 PATCH 0007 - Bump the driver version 


Thanks
Jay

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---

