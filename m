From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 12/13] hpsa: use usleep_range not msleep for small sleeps
Date: Fri, 08 Oct 2010 15:07:03 -0500
Message-ID: <20101008200703.24279.96566.stgit@beardog.cce.hp.com>
References: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com
Cc: akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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
 
