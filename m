From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 25/30] hpsa: clarify obscure comment in adjust_hpsa_scsi_table
Date: Thu, 04 Feb 2010 08:43:31 -0600
Message-ID: <20100204144331.10406.36348.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:32055 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933096Ab0BDOkn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2010 09:40:43 -0500
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: clarify obscure comment in adjust_hpsa_scsi_table

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b91ccd4..42295c4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -838,7 +838,11 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 			(void) hpsa_scsi_add_entry(h, hostno, sd[entry],
 				added, &nadded);
 			/* add can't fail, we just removed one. */
-			sd[entry] = NULL; /* prevent it from being freed */
+
+			/* Set it to NULL to prevent it from being freed
+			 * at the bottom of hpsa_update_scsi_devices()
+			 */
+			sd[entry] = NULL;
 		}
 		i++;
 	}

