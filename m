From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 17/24] hpsa: remove bad unlikely annotation from device list
	updating code
Date: Thu, 29 May 2014 10:53:49 -0500
Message-ID: <20140529155349.8180.9401.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:19883 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965022AbaE2PzQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:55:16 -0400
Received: from g2t2354.austin.hp.com (g2t2354.austin.hp.com [15.217.128.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id EEF77E99
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 15:35:58 +0000 (UTC)
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Justin Lindley <justin.lindley@hp.com>
Reviewed-by: Mike Miller <michael.miller@canonical.com>
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

