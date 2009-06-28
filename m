From: Joe Perches <joe@perches.com>
Subject: [PATCH 43/62] include/scsi/fc/fc_fc2.h: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:48 -0700
Message-ID: <0a9097272c9d128edccdf4783d8e2b1b7e98cb22.1246173682.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1155 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223AbZF1Q17 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2009 12:27:59 -0400
In-Reply-To: <cover.1246173664.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/scsi/fc/fc_fc2.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/scsi/fc/fc_fc2.h b/include/scsi/fc/fc_fc2.h
index cff8a8c..f87777d 100644
--- a/include/scsi/fc/fc_fc2.h
+++ b/include/scsi/fc/fc_fc2.h
@@ -92,8 +92,7 @@ struct fc_esb {
 	__u8	_esb_resvd[4];
 	__u8	esb_service_params[112]; /* TBD */
 	__u8	esb_seq_status[8];	/* sequence statuses, 8 bytes each */
-} __attribute__((packed));;
-
+} __attribute__((packed));
 
 /*
  * Define expected size for ASSERTs.
-- 
1.6.3.1.10.g659a0.dirty

