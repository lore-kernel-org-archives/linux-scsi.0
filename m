From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH 33a/33] include/scsi/scsi_tcq.h: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:05:38 +0100 (MET)
Message-ID: <20080106030538.30002.11018.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:54064 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbYAFDFu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:05:50 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---


diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index cf4c219..341ed5a 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -86,7 +86,7 @@ static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
 
 /**
  * scsi_populate_tag_msg - place a tag message in a buffer
- * @SCpnt:	pointer to the Scsi_Cmnd for the tag
+ * @SCpnt:	pointer to the scsi_cmnd for the tag
  * @msg:	pointer to the area to place the tag
  *
  * Notes:
