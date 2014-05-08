From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 17/19] hpsa: remove bad unlikely annotation from device list
	updating code
Date: Thu, 08 May 2014 14:28:50 -0500
Message-ID: <20140508192850.13481.51502.stgit@beardog.cce.hp.com>
References: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:31492 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbaEHT3l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2014 15:29:41 -0400
In-Reply-To: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: justin.lindley@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8359884..9d4a0bd 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3060,7 +3060,7 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 		ndev_allocated++;
 	}
 
-	if (unlikely(is_scsi_rev_5(h)))
+	if (is_scsi_rev_5(h))
 		raid_ctlr_position = 0;
 	else
 		raid_ctlr_position = nphysicals + nlogicals;

