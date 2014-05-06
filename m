From: Jay Kallickal <jayamohank@gmail.com>
Subject: [PATCH 0/8] be2iscsi: update to 10.2.273.0
Date: Mon,  5 May 2014 21:41:32 -0400
Message-ID: <1399340492-2136-9-git-send-email-jkallickal@emulex.com>
References: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60131 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933469AbaEFBmC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2014 21:42:02 -0400
Received: by mail-pa0-f44.google.com with SMTP id ld10so5362757pab.31
        for <linux-scsi@vger.kernel.org>; Mon, 05 May 2014 18:42:00 -0700 (PDT)
In-Reply-To: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>


 This patchset updates be2iscsi driver to 10.2.273.0.

This patchset supercedes any patches that have been submitted
but not accepted

These patches are based on scsi-misc branch of scsi.git.

0001 - Fix retrieving MCCQ_WRB in non embedded Mbox
0002 - Fix exposing Host in sysfs after adapter init is done
0003 - Fix interrupt Coalescing mechanism
0004 - Fix TCP parameters while connection offloadling
0005 - Fix memory corruption in MBX path
0006 - Fix destroy MCC CQ before MCC EQ is destroy.patch
0007 - Fix processing cqe for cxn whose endpoint is freed 
0008 - Bump the driver version

Thanks
Jay

Signed-off-by: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>
---
