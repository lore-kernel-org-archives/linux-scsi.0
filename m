From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 06/16] hpsa: wait longer for no-op to complete after resetting
	controller
Date: Tue, 03 May 2011 14:59:15 -0500
Message-ID: <20110503195915.5478.72321.stgit@beardog.cce.hp.com>
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

This is to avoid the usual two or three messages about the command
timing out.  We're obviously not waiting long enough.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 7eec397..7a4ee73 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -130,7 +130,7 @@ struct ctlr_info {
 #define HPSA_BUS_RESET_MSG 2
 #define HPSA_HOST_RESET_MSG 3
 #define HPSA_MSG_SEND_RETRY_LIMIT 10
-#define HPSA_MSG_SEND_RETRY_INTERVAL_MSECS 1000
+#define HPSA_MSG_SEND_RETRY_INTERVAL_MSECS (10000)
 
 /* Maximum time in seconds driver will wait for command completions
  * when polling before giving up.
