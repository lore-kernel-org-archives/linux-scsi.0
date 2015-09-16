From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] [SCSI] FlashPoint: fix build warning
Date: Wed, 16 Sep 2015 19:36:20 +0530
Message-ID: <1442412380-1832-1-git-send-email-sudipm.mukherjee@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Khalid Aziz <khalid@gonehiking.org>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
List-Id: linux-scsi@vger.kernel.org

We have been getting a warning about non ANSI function.
warning: non-ANSI function declaration of function 'FPT_SccbMgrTableInitAll'

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/scsi/FlashPoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index 5c74e4c..867b864 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -2136,7 +2136,7 @@ static unsigned char FPT_SccbMgr_bad_isr(u32 p_port, unsigned char p_card,
  *
  *---------------------------------------------------------------------*/
 
-static void FPT_SccbMgrTableInitAll()
+static void FPT_SccbMgrTableInitAll(void)
 {
 	unsigned char thisCard;
 
-- 
1.9.1
