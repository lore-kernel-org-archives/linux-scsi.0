From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 29/29] MAINTAINERS: Update be2iscsi contact info
Date: Fri, 19 Aug 2016 15:20:26 +0530
Message-ID: <1471600226-22055-30-git-send-email-jitendra.bhivare@broadcom.com>
References: <1471600226-22055-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:33296 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754498AbcHSJwR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Aug 2016 05:52:17 -0400
Received: by mail-wm0-f47.google.com with SMTP id d196so7884025wmd.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2016 02:52:16 -0700 (PDT)
In-Reply-To: <1471600226-22055-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 MAINTAINERS | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5f50224..fec431c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10562,12 +10562,12 @@ S:	Maintained
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

