From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 09/16] hpsa: increase time to wait for board reset
Date: Tue, 03 May 2011 14:59:31 -0500
Message-ID: <20110503195931.5478.71892.stgit@beardog.cce.hp.com>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 7a4ee73..b1412a7 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -155,7 +155,7 @@ struct ctlr_info {
  * HPSA_BOARD_READY_ITERATIONS are derived from those.
  */
 #define HPSA_BOARD_READY_WAIT_SECS (120)
-#define HPSA_BOARD_NOT_READY_WAIT_SECS (10)
+#define HPSA_BOARD_NOT_READY_WAIT_SECS (100)
 #define HPSA_BOARD_READY_POLL_INTERVAL_MSECS (100)
 #define HPSA_BOARD_READY_POLL_INTERVAL \
 	((HPSA_BOARD_READY_POLL_INTERVAL_MSECS * HZ) / 1000)
