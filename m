From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 0/8] be2iscsi: Update to 10.2.125.0
Date: Wed, 29 Jan 2014 02:16:47 -0500
Message-ID: <1390979807-16718-9-git-send-email-Jayamohan.Kallickal@emulex.com>
References: <1390979807-16718-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:46461 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaA2HRK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jan 2014 02:17:10 -0500
Received: by mail-pb0-f51.google.com with SMTP id un15so1397980pbc.24
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2014 23:17:10 -0800 (PST)
In-Reply-To: <1390979807-16718-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

This patchset updates be2iscsi driver to 10.2.125.0. 

Regarding comments by Mike Christie  on Version 1 

 Patch 5/7) - converted to common function
 Patch 4/7  - Will withdraw for now as there is lots of
		changes to be done.

These patches are based of scsi.git scsi

 0001 - Fix handling timed out MBX completion from FW
 0002 - Fix port speed typo in driver
 0003 - Fix IRQ_Affinity support in driver
 0004 - Fix doorbell format for EQ CQ RQ per SLI
 0005 - Fix the session cleanup when reboot shutdown
 0006 - Fix scsi_cmnd leakage in driver
 0007 - Fix DMA Out of SW IOMMU space error
 0008 - Bump the driver version


Thanks
Jay

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
