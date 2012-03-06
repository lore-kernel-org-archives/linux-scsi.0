From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 2/3] qla4xxx: Removed packed attr from struct iscsi_chap_rec
Date: Tue, 6 Mar 2012 04:16:05 -0800
Message-ID: <1331036166-19496-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1331036166-19496-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:30762 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030546Ab2CFM3t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2012 07:29:49 -0500
In-Reply-To: <1331036166-19496-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

We don't need to pack 'struct iscsi_chap_rec' as buffer is built
locally in the driver and pass to the user-space.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 include/scsi/iscsi_if.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index eab830a..917741b 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -593,6 +593,6 @@ struct iscsi_chap_rec {
 	char username[ISCSI_CHAP_AUTH_NAME_MAX_LEN];
 	uint8_t password[ISCSI_CHAP_AUTH_SECRET_MAX_LEN];
 	uint8_t password_length;
-} __packed;
+};
 
 #endif
-- 
1.7.9.1.265.gb3a76


