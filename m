From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: csiostor: fix spelling mistake: "Couldnt" -> "Couldn't"
Date: Fri,  1 Dec 2017 09:40:09 +0000
Message-ID: <20171201094009.9394-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Varun Prakash <varun@chelsio.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in error message text.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/csiostor/csio_mb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_mb.c b/drivers/scsi/csiostor/csio_mb.c
index 931b1d8f9f3e..5f4e0a787bd1 100644
--- a/drivers/scsi/csiostor/csio_mb.c
+++ b/drivers/scsi/csiostor/csio_mb.c
@@ -1216,7 +1216,7 @@ csio_mb_issue(struct csio_hw *hw, struct csio_mb *mbp)
 		/* Queue mbox cmd, if another mbox cmd is active */
 		if (mbp->mb_cbfn == NULL) {
 			rv = -EBUSY;
-			csio_dbg(hw, "Couldnt own Mailbox %x op:0x%x\n",
+			csio_dbg(hw, "Couldn't own Mailbox %x op:0x%x\n",
 				    hw->pfn, *((uint8_t *)mbp->mb));
 
 			goto error_out;
@@ -1244,14 +1244,14 @@ csio_mb_issue(struct csio_hw *hw, struct csio_mb *mbp)
 				rv = owner ? -EBUSY : -ETIMEDOUT;
 
 				csio_dbg(hw,
-					 "Couldnt own Mailbox %x op:0x%x "
+					 "Couldn't own Mailbox %x op:0x%x "
 					 "owner:%x\n",
 					 hw->pfn, *((uint8_t *)mbp->mb), owner);
 				goto error_out;
 			} else {
 				if (mbm->mcurrent == NULL) {
 					csio_err(hw,
-						 "Couldnt own Mailbox %x "
+						 "Couldn't own Mailbox %x "
 						 "op:0x%x owner:%x\n",
 						 hw->pfn, *((uint8_t *)mbp->mb),
 						 owner);
-- 
2.14.1
