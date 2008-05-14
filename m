From: akpm@linux-foundation.org
Subject: [patch 6/9] scsi: use get_unaligned_* helpers
Date: Wed, 14 May 2008 16:23:33 -0700
Message-ID: <200805142323.m4ENNX3u026862@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754884AbYENXYI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2008 19:24:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, harvey.harrison@gmail.com

From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libiscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/libiscsi.c~scsi-use-get_unaligned_-helpers drivers/scsi/libiscsi.c
--- a/drivers/scsi/libiscsi.c~scsi-use-get_unaligned_-helpers
+++ a/drivers/scsi/libiscsi.c
@@ -508,7 +508,7 @@ invalid_datalen:
 			goto out;
 		}
 
-		senselen = be16_to_cpu(get_unaligned((__be16 *) data));
+		senselen = get_unaligned_be16(data);
 		if (datalen < senselen)
 			goto invalid_datalen;
 
_
