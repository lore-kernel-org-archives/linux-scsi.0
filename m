From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 1/3] scsi: add WRITE_VERIFY_16 to scsi.h
Date: Thu,  8 Jan 2015 11:47:57 -0800
Message-ID: <1420746479-25949-2-git-send-email-agrover@redhat.com>
References: <1420746479-25949-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757156AbbAHTsH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2015 14:48:07 -0500
In-Reply-To: <1420746479-25949-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, hch@lst.de

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 include/scsi/scsi.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 8a7f8ad..faf2118 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -150,6 +150,7 @@ enum scsi_timeouts {
 #define WRITE_16              0x8a
 #define READ_ATTRIBUTE        0x8c
 #define WRITE_ATTRIBUTE	      0x8d
+#define WRITE_VERIFY_16       0x8e
 #define VERIFY_16	      0x8f
 #define SYNCHRONIZE_CACHE_16  0x91
 #define WRITE_SAME_16	      0x93
-- 
2.1.0

