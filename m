From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 18/24] hpsa: remove unused variable trans_offset
Date: Thu, 27 May 2010 15:14:13 -0500
Message-ID: <20100527201413.3116.37142.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:31074 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab0E0UJe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:09:34 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: remove unused variable trans_offset

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 052f0a4..bd2e0c6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3819,7 +3819,6 @@ static void  calc_bucket_map(int bucket[], int num_buckets,
 static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 {
 	u32 trans_support;
-	u64 trans_offset;
 	/*  5 = 1 s/g entry or 4k
 	 *  6 = 2 s/g entry or 8k
 	 *  8 = 4 s/g entry or 16k
@@ -3854,7 +3853,6 @@ static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 	memset(h->reply_pool, 0, h->reply_pool_size);
 	h->reply_pool_head = h->reply_pool;
 
-	trans_offset = readl(&(h->cfgtable->TransMethodOffset));
 	bft[7] = h->max_sg_entries + 4;
 	calc_bucket_map(bft, ARRAY_SIZE(bft), 32, h->blockFetchTable);
 	for (i = 0; i < 8; i++)

