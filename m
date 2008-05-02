From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 4/8] scsi: use get_unaligned_* helpers
Date: Thu, 01 May 2008 20:52:56 -0700
Message-ID: <1209700376.22362.19.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:48430 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605AbYEBDwi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 23:52:38 -0400
Received: by wa-out-1112.google.com with SMTP id j37so54279waf.23
        for <linux-scsi@vger.kernel.org>; Thu, 01 May 2008 20:52:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/libiscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 010c1b9..7646e86 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -508,7 +508,7 @@ invalid_datalen:
 			goto out;
 		}
 
-		senselen = be16_to_cpu(get_unaligned((__be16 *) data));
+		senselen = get_unaligned_be16(data);
 		if (datalen < senselen)
 			goto invalid_datalen;
 
-- 
1.5.5.1.350.gbbbf


