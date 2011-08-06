From: Dan Carpenter <error27@gmail.com>
Subject: [patch] iscsi-target: remove duplicate return
Date: Sat, 6 Aug 2011 07:29:38 -0700
Message-ID: <20110806142938.GD10373@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63062 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1HFO3h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Aug 2011 10:29:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Grover <agrover@redhat.com>, Dan Carpenter <error27@gmail.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, kernel-janitors@vger.kernel.org

We returned on the line before already.

Signed-off-by: Dan Carpenter <error27@gmail.com>

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
