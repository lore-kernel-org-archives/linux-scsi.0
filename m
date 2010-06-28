From: Kulikov Vasiliy <segooon@gmail.com>
Subject: [PATCH 08/16] trivial: use ARRAY_SIZE
Date: Mon, 28 Jun 2010 15:55:12 +0400
Message-ID: <1277726113-24666-1-git-send-email-segooon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: trivial@kernel.org
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>, Robert Love <robert.w.love@intel.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Vasu Dev <vasu.dev@intel.com>, Joe Eykholt <jeykholt@cisco.com>, devel@open-fcoe.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/scsi/libfc/fc_exch.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 104e0fb..ca52bfa 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -219,8 +219,6 @@ static void fc_exch_els_rrq(struct fc_seq *, struct fc_frame *);
  */
 static char *fc_exch_rctl_names[] = FC_RCTL_NAMES_INIT;
 
-#define FC_TABLE_SIZE(x)   (sizeof(x) / sizeof(x[0]))
-
 /**
  * fc_exch_name_lookup() - Lookup name by opcode
  * @op:	       Opcode to be looked up
@@ -249,7 +247,7 @@ static inline const char *fc_exch_name_lookup(unsigned int op, char **table,
 static const char *fc_exch_rctl_name(unsigned int op)
 {
 	return fc_exch_name_lookup(op, fc_exch_rctl_names,
-				   FC_TABLE_SIZE(fc_exch_rctl_names));
+				   ARRAY_SIZE(fc_exch_rctl_names));
 }
 
 /**
-- 
1.7.0.4
