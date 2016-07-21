From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 28/28] MAINTAINERS: Update be2iscsi contact info
Date: Thu, 21 Jul 2016 14:38:05 +0530
Message-ID: <1469092085-14311-29-git-send-email-jitendra.bhivare@broadcom.com>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35174 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbcGUJJy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2016 05:09:54 -0400
Received: by mail-wm0-f43.google.com with SMTP id f65so14871057wmi.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 02:09:53 -0700 (PDT)
In-Reply-To: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 MAINTAINERS | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5a367e5..0559054 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10273,12 +10273,12 @@ S:	Maintained
 F:	drivers/misc/phantom.c
 F:	include/uapi/linux/phantom.h
 
-SERVER ENGINES 10Gbps iSCSI - BladeEngine 2 DRIVER
-M:	Jayamohan Kallickal <jayamohan.kallickal@avagotech.com>
-M:	Ketan Mukadam <ketan.mukadam@avagotech.com>
-M:	John Soni Jose <sony.john@avagotech.com>
+Emulex 10Gbps iSCSI - OneConnect DRIVER
+M:	Subbu Seetharaman <subbu.seetharaman@broadcom.com>
+M:	Ketan Mukadam <ketan.mukadam@broadcom.com>
+M:	Jitendra Bhivare <jitendra.bhivare@broadcom.com>
 L:	linux-scsi@vger.kernel.org
-W:	http://www.avagotech.com
+W:	http://www.broadcom.com
 S:	Supported
 F:	drivers/scsi/be2iscsi/
 
-- 
1.9.1

