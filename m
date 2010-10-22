From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 07/10] hpsa: use usleep_range not msleep for small sleeps
Date: Fri, 22 Oct 2010 14:27:55 -0500
Message-ID: <20101022192755.25694.82762.stgit@beardog.cce.hp.com>
References: <20101022192315.25694.28983.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:5648 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759133Ab0JVT14 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Oct 2010 15:27:56 -0400
In-Reply-To: <20101022192315.25694.28983.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com, linux-scsi@vger.kernel.org, smcameron@yahoo.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a68dba7..c36427d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3594,7 +3594,7 @@ static void __devinit hpsa_wait_for_mode_change_ack(struct ctlr_info *h)
 		if (!doorbell_value & CFGTBL_ChangeReq)
 			break;
 		/* delay and try again */
-		msleep(10);
+		usleep_range(10000, 20000);
 	}
 }
 

