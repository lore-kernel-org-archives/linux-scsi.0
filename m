From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/24] fcoe: remove extra function decalrations
Date: Fri, 18 Sep 2009 15:49:30 -0700
Message-ID: <20090918224930.5928.53480.stgit@localhost.localdomain>
References: <20090918224847.5928.52092.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:45708 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758772AbZIRWt1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 18:49:27 -0400
In-Reply-To: <20090918224847.5928.52092.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

Remove the two extra function decalartions in fcoe.c.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index c3d5364..27fcfdc 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -102,9 +102,6 @@ static int fcoe_cpu_callback(struct notifier_block *, unsigned long, void *);
 static int fcoe_create(const char *, struct kernel_param *);
 static int fcoe_destroy(const char *, struct kernel_param *);
 
-static u8 *fcoe_get_src_mac(struct fc_lport *);
-static void fcoe_destroy_work(struct work_struct *);
-
 static struct fc_seq *fcoe_elsct_send(struct fc_lport *,
 				      u32 did, struct fc_frame *,
 				      unsigned int op,

