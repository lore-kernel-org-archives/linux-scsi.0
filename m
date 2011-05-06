From: vikas.chaudhary@qlogic.com
Subject: [RFC PATCH 1/3] scsi_transport_iscsi: Add flag CAP_LOGIN_OFFLOAD
Date: Fri,  6 May 2011 05:29:51 -0700
Message-ID: <1304684993-1715-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1304684993-1715-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36725 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752288Ab1EFMgC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2011 08:36:02 -0400
In-Reply-To: <1304684993-1715-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Add capability for offloading session login.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 include/scsi/iscsi_if.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 86f6f1a..ad9fb02 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -481,6 +481,7 @@ enum iscsi_host_param {
 #define CAP_DIGEST_OFFLOAD	0x1000	/* offload hdr and data digests */
 #define CAP_PADDING_OFFLOAD	0x2000	/* offload padding insertion, removal,
 					 and verification */
+#define CAP_LOGIN_OFFLOAD	0x4000  /* offload session login */
 
 /*
  * These flags describes reason of stop_conn() call
-- 
1.7.3.2

