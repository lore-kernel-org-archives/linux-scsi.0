From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 05/21]drivers:scsi:ips.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:10:58 -0800
Message-ID: <1298614258-3610-1-git-send-email-justinmattock@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: trivial@kernel.org
Cc: ipslinux@adaptec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Justin P. Mattock" <justinmattock@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/ips.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index b2511ac..ece1445 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -4494,7 +4494,7 @@ ips_init_scb(ips_ha_t * ha, ips_scb_t * scb)
 /*                                                                          */
 /*   Initialize a CCB to default values                                     */
 /*                                                                          */
-/* ASSUMED to be callled from within a lock                                 */
+/* ASSUMED to be called from within a lock                                 */
 /*                                                                          */
 /****************************************************************************/
 static ips_scb_t *
-- 
1.7.4.1
