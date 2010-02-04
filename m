From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 05/30] hpsa: make adjust_hpsa_scsi_table return void.
Date: Thu, 04 Feb 2010 08:41:49 -0600
Message-ID: <20100204144149.10406.67225.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: make adjust_hpsa_scsi_table return void.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 2c256e3..6fe5142 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -733,7 +733,7 @@ static int hpsa_scsi_find_entry(struct hpsa_scsi_dev_t *needle,
 	return DEVICE_NOT_FOUND;
 }
 
-static int adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
+static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 	struct hpsa_scsi_dev_t *sd[], int nsds)
 {
 	/* sd contains scsi3 addresses and devtypes, and inquiry
@@ -859,7 +859,6 @@ static int adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
 free_and_out:
 	kfree(added);
 	kfree(removed);
-	return 0;
 }
 
 /*
