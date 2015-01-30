From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv2 1/5] scsi: add WRITE_VERIFY_16 to scsi.h
Date: Thu, 29 Jan 2015 16:56:33 -0800
Message-ID: <1422579397-18696-2-git-send-email-agrover@redhat.com>
References: <1422579397-18696-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758279AbbA3A4p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2015 19:56:45 -0500
In-Reply-To: <1422579397-18696-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, hch@lst.de

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 include/scsi/scsi.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index d0a66aa..cf778fe 100644
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

