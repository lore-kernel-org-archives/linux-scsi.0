From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] make scsi_end_bidi_request() static
Date: Wed, 27 Feb 2008 23:20:13 +0200
Message-ID: <20080227212013.GG29269@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.pp.htv.fi ([213.243.153.38]:41737 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392AbYB0VVY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Feb 2008 16:21:24 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This patch makes the needlessly global scsi_end_bidi_request() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 13 Feb 2008

48e50a33ee11afb02eadc790ae2d9542b0805608 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b12fb31..148c8b0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -785,7 +785,7 @@ EXPORT_SYMBOL(scsi_release_buffers);
  * in req->data_len and req->next_rq->data_len. The upper-layer driver can
  * decide what to do with this information.
  */
-void scsi_end_bidi_request(struct scsi_cmnd *cmd)
+static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
 {
 	struct request *req = cmd->request;
 	unsigned int dlen = req->data_len;

