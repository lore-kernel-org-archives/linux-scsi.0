From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 47/48] hpsa: add in P840ar controller model name
Date: Fri, 23 Jan 2015 16:45:12 -0600
Message-ID: <20150123224512.14919.60430.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:31209 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbbAWWqG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:46:06 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

Add in P840ar model name for gen9

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6568da5..15ef65c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -172,7 +172,7 @@ static struct board_type products[] = {
 	{0x21BE103C, "Smart Array P741m", &SA5_access},
 	{0x21BF103C, "Smart HBA H240ar", &SA5_access},
 	{0x21C0103C, "Smart Array P440ar", &SA5_access},
-	{0x21C1103C, "Smart Array", &SA5_access},
+	{0x21C1103C, "Smart Array P840ar", &SA5_access},
 	{0x21C2103C, "Smart Array P440", &SA5_access},
 	{0x21C3103C, "Smart Array P441", &SA5_access},
 	{0x21C4103C, "Smart Array", &SA5_access},

