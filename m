From: Joe Perches <joe@perches.com>
Subject: [PATCH 26/44] drivers/scsi/qla2xxx: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:45 -0800
Message-ID: <40854ce1b1e958e2c0bb9b79911d89b45b5e5f27.1289789605.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1202 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932797Ab0KODFo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:44 -0500
In-Reply-To: <cover.1289789604.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    4 ++--
 drivers/scsi/qla2xxx/qla_nx.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 1f06ddd..59c4870 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1049,7 +1049,7 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 		}
 		DEBUG2(qla2x00_dump_buffer((uint8_t *)pkt, sizeof(*pkt)));
 	} else {
-		bsg_job->reply->result =  DID_OK << 16;;
+		bsg_job->reply->result =  DID_OK << 16;
 		bsg_job->reply->reply_payload_rcv_len =
 		    bsg_job->reply_payload.payload_len;
 		bsg_job->reply_len = 0;
@@ -1144,7 +1144,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 		DEBUG2(qla2x00_dump_buffer((uint8_t *)pkt, sizeof(*pkt)));
 	}
 	else {
-		bsg_job->reply->result =  DID_OK << 16;;
+		bsg_job->reply->result =  DID_OK << 16;
 		bsg_job->reply->reply_payload_rcv_len = bsg_job->reply_payload.payload_len;
 		bsg_job->reply_len = 0;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 8d9edfb..de2d1eb 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1022,7 +1022,7 @@ ql82xx_rom_lock_d(struct qla_hw_data *ha)
 		qla_printk(KERN_WARNING, ha, "ROM lock failed\n");
 		return -1;
 	}
-	return 0;;
+	return 0;
 }
 
 static int
-- 
1.7.3.1.g432b3.dirty

