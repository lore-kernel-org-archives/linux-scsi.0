From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 05/17] hpsa: Allocate the correct amount of extra space for
	the scsi host
Date: Wed, 11 Nov 2009 10:50:48 -0600
Message-ID: <20091111165048.17754.12645.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:37684 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849AbZKKQtX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2009 11:49:23 -0500
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com

hpsa: Allocate the correct amount of extra space for the scsi host

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e402155..85be09c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -890,7 +890,7 @@ static int hpsa_scsi_detect(struct ctlr_info *h)
 	struct Scsi_Host *sh;
 	int error;
 
-	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(*h));
+	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(h));
 	if (sh == NULL)
 		goto fail;
 

