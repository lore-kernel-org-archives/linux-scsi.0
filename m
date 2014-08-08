From: Jay Kallickal <jayamohank@gmail.com>
Subject: [PATCH 0/5] be2iscsi: Update to 10.4.74.0
Date: Fri,  8 Aug 2014 01:00:03 -0400
Message-ID: <1407474003-26220-6-git-send-email-jkallickal@emulex.com>
References: <1407474003-26220-1-git-send-email-jkallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49247 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaHHFAW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2014 01:00:22 -0400
Received: by mail-pd0-f172.google.com with SMTP id y13so458616pdi.17
        for <linux-scsi@vger.kernel.org>; Thu, 07 Aug 2014 22:00:21 -0700 (PDT)
In-Reply-To: <1407474003-26220-1-git-send-email-jkallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 This patchset updates be2iscsi driver to 10.4.74.0

These patches are based on for-next branch of scsi.git.

0001 - Fix the sparse warning  
0002 - Update the copyright year
0003 - Fix updating the boot enteries in sysfs
0004 - Fix processing CQE before freeing connection resources
0005 - Bump the driver version

Thanks
Jay

Signed-off-by: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>
---
