From: Vinayak Holikatti <vinholikatti@gmail.com>
Subject: [PATCH] [SCSI] ufs: Update MAINTAINERS
Date: Fri, 20 Apr 2012 14:11:50 +0530
Message-ID: <1334911310-16150-1-git-send-email-vinholikatti@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:35935 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab2DTInJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Apr 2012 04:43:09 -0400
Received: by dake40 with SMTP id e40so12728765dak.11
        for <linux-scsi@vger.kernel.org>; Fri, 20 Apr 2012 01:43:09 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, santoshsy@gmail.com, Vinayak Holikatti <vinholikatti@gmail.com>

Add myself and Santosh Y as maintainers for scsi/ufs/

Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2dcfca8..526d0e1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6876,6 +6876,14 @@ F:	Documentation/cdrom/
 F:	drivers/cdrom/cdrom.c
 F:	include/linux/cdrom.h
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER
+M:	Vinayak Holikatti <vinholikatti@gmail.com>
+M:	Santosh Y <santoshsy@gmail.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	Documentation/scsi/ufs.txt
+F:	drivers/scsi/ufs/
+
 UNSORTED BLOCK IMAGES (UBI)
 M:	Artem Bityutskiy <dedekind1@gmail.com>
 W:	http://www.linux-mtd.infradead.org/
-- 
1.7.5.4

