From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 4/9] hpsa: return -ENOMEM, not -1
Date: Thu, 25 Feb 2010 14:03:06 -0600
Message-ID: <20100225200306.7508.14148.stgit@beardog.cce.hp.com>
References: <20100225200125.7508.11486.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:40980 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430Ab0BYT75 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 14:59:57 -0500
In-Reply-To: <20100225200125.7508.11486.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@suse.de, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: return -ENOMEM, not -1

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 604b4c9..a72a18e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1386,7 +1386,7 @@ static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr)
 
 	if (c == NULL) {			/* trouble... */
 		dev_warn(&h->pdev->dev, "cmd_special_alloc returned NULL!\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	fill_cmd(c, HPSA_DEVICE_RESET_MSG, h, NULL, 0, 0, scsi3addr, TYPE_MSG);

