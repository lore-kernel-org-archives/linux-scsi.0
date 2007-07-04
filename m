From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] scsi.c: convert to use the data buffer accessors
Date: Wed, 04 Jul 2007 21:26:01 +0300
Message-ID: <468BE639.7040104@panasas.com>
References: <468BE4CE.80402@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:47002 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755140AbXGDS0N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jul 2007 14:26:13 -0400
In-Reply-To: <468BE4CE.80402@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>


 - a couple of prints, they can use the accessors

 Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 4c1e313..1d1aba6 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -368,7 +368,7 @@ void scsi_log_send(struct scsi_cmnd *cmd)
 			if (level > 3) {
 				printk(KERN_INFO "buffer = 0x%p, bufflen = %d,"
 				       " done = 0x%p, queuecommand 0x%p\n",
-					cmd->request_buffer, cmd->request_bufflen,
+					scsi_sglist(cmd), scsi_bufflen(cmd),
 					cmd->done,
 					cmd->device->host->hostt->queuecommand);

-- 
1.5.2.2.249.g45fd


