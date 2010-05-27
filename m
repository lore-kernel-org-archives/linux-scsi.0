From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 16/24] hpsa: mark hpsa_mark_hpsa_put_ctlr_into_performant_mode
	as __devinit
Date: Thu, 27 May 2010 15:14:03 -0500
Message-ID: <20100527201403.3116.87368.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:40746 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab0E0UJY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:09:24 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: mark hpsa_mark_hpsa_put_ctlr_into_performant_mode as __devinit

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b34ee41..a43f3cb 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -158,7 +158,7 @@ static void check_ioctl_unit_attention(struct ctlr_info *h,
 /* performant mode helper functions */
 static void calc_bucket_map(int *bucket, int num_buckets,
 	int nsgs, int *bucket_map);
-static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h);
+static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h);
 static inline u32 next_command(struct ctlr_info *h);
 
 static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
@@ -3811,7 +3811,7 @@ static void  calc_bucket_map(int bucket[], int num_buckets,
 	}
 }
 
-static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
+static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 {
 	u32 trans_support;
 	u64 trans_offset;

