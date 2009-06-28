From: Joe Perches <joe@perches.com>
Subject: [PATCH 42/62] drivers/scsi/bnx2i/bnx2i_hwi.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:47 -0700
Message-ID: <cc702ae6f0259b9e501e89cc38e8b6663b056d04.1246173682.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1153 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757184AbZF1Q16 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2009 12:27:58 -0400
In-Reply-To: <cover.1246173664.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 906cef5..41e1b0e 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1340,7 +1340,7 @@ static int bnx2i_process_login_resp(struct iscsi_session *session,
 	resp_hdr->opcode = login->op_code;
 	resp_hdr->flags = login->response_flags;
 	resp_hdr->max_version = login->version_max;
-	resp_hdr->active_version = login->version_active;;
+	resp_hdr->active_version = login->version_active;
 	resp_hdr->hlength = 0;
 
 	hton24(resp_hdr->dlength, login->data_length);
-- 
1.6.3.1.10.g659a0.dirty

