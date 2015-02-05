From: Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH] bfa: bfa_core: fix sparse warning
Date: Thu,  5 Feb 2015 10:10:27 +0000
Message-ID: <1423131027-7563-1-git-send-email-prabhakar.csengg@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch fixes following sparse warning:

bfa_core.c:716:1: warning: symbol 'bfa_isr_rspq' was not declared. Should it be static?

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Found this issue on linux-next (gcc  version 4.9.2,
 sparse version  0.4.5-rc1)and applies on top linux-next.

 drivers/scsi/bfa/bfa_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index e3f67b0..2a613d2 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -712,7 +712,7 @@ bfa_reqq_resume(struct bfa_s *bfa, int qid)
 	}
 }
 
-bfa_boolean_t
+static bfa_boolean_t
 bfa_isr_rspq(struct bfa_s *bfa, int qid)
 {
 	struct bfi_msg_s *m;
-- 
1.9.1
