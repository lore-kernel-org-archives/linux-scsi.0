From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 46/48] hpsa: add in gen9 controller model names
Date: Fri, 23 Jan 2015 16:45:07 -0600
Message-ID: <20150123224507.14919.54976.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:35876 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbbAWWqA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:46:00 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

Add in gen9 controller model names

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c1f4a95..6568da5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -168,24 +168,24 @@ static struct board_type products[] = {
 	{0x1926103C, "Smart Array P731m", &SA5_access},
 	{0x1928103C, "Smart Array P230i", &SA5_access},
 	{0x1929103C, "Smart Array P530", &SA5_access},
-	{0x21BD103C, "Smart Array", &SA5_access},
-	{0x21BE103C, "Smart Array", &SA5_access},
-	{0x21BF103C, "Smart Array", &SA5_access},
-	{0x21C0103C, "Smart Array", &SA5_access},
+	{0x21BD103C, "Smart Array P244br", &SA5_access},
+	{0x21BE103C, "Smart Array P741m", &SA5_access},
+	{0x21BF103C, "Smart HBA H240ar", &SA5_access},
+	{0x21C0103C, "Smart Array P440ar", &SA5_access},
 	{0x21C1103C, "Smart Array", &SA5_access},
-	{0x21C2103C, "Smart Array", &SA5_access},
-	{0x21C3103C, "Smart Array", &SA5_access},
+	{0x21C2103C, "Smart Array P440", &SA5_access},
+	{0x21C3103C, "Smart Array P441", &SA5_access},
 	{0x21C4103C, "Smart Array", &SA5_access},
-	{0x21C5103C, "Smart Array", &SA5_access},
-	{0x21C6103C, "Smart Array", &SA5_access},
-	{0x21C7103C, "Smart Array", &SA5_access},
-	{0x21C8103C, "Smart Array", &SA5_access},
+	{0x21C5103C, "Smart Array P841", &SA5_access},
+	{0x21C6103C, "Smart HBA H244br", &SA5_access},
+	{0x21C7103C, "Smart HBA H240", &SA5_access},
+	{0x21C8103C, "Smart HBA H241", &SA5_access},
 	{0x21C9103C, "Smart Array", &SA5_access},
-	{0x21CA103C, "Smart Array", &SA5_access},
-	{0x21CB103C, "Smart Array", &SA5_access},
+	{0x21CA103C, "Smart Array P246br", &SA5_access},
+	{0x21CB103C, "Smart Array P840", &SA5_access},
 	{0x21CC103C, "Smart Array", &SA5_access},
 	{0x21CD103C, "Smart Array", &SA5_access},
-	{0x21CE103C, "Smart Array", &SA5_access},
+	{0x21CE103C, "Smart HBA", &SA5_access},
 	{0x00761590, "HP Storage P1224 Array Controller", &SA5_access},
 	{0x00871590, "HP Storage P1224e Array Controller", &SA5_access},
 	{0x007D1590, "HP Storage P1228 Array Controller", &SA5_access},

