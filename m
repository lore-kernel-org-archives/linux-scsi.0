From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 06/21] iscsi-target: remove duplicate return
Date: Wed, 17 Aug 2011 23:17:10 +0000
Message-ID: <1313623045-15916-7-git-send-email-nab@linux-iscsi.org>
References: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58306 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab1HQXmY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 19:42:24 -0400
In-Reply-To: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Dan Carpenter <error27@gmail.com>

From: Dan Carpenter <error27@gmail.com>

We returned on the line before already.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index c24fb10..6a4ea29 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2243,7 +2243,6 @@ static int iscsit_handle_snack(
 	case 0:
 		return iscsit_handle_recovery_datain_or_r2t(conn, buf,
 			hdr->itt, hdr->ttt, hdr->begrun, hdr->runlength);
-		return 0;
 	case ISCSI_FLAG_SNACK_TYPE_STATUS:
 		return iscsit_handle_status_snack(conn, hdr->itt, hdr->ttt,
 			hdr->begrun, hdr->runlength);
-- 
1.7.6

