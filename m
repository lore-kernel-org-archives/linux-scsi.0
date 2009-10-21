From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 18/20] fnic: Set max_cmd_len to driver supported CDB length
Date: Wed, 21 Oct 2009 16:28:19 -0700
Message-ID: <20091021232819.12986.32058.stgit@localhost.localdomain>
References: <20091021232640.12986.79205.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:54823 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbZJUXaN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2009 19:30:13 -0400
In-Reply-To: <20091021232640.12986.79205.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Abhijeet Joglekar <abjoglek@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Abhijeet Joglekar <abjoglek@cisco.com>

Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fnic/fnic.h      |    2 +-
 drivers/scsi/fnic/fnic_main.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index e4c0a3d..1bc267e 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -44,7 +44,7 @@
 #define	FNIC_IO_LOCKS		64 /* IO locks: power of 2 */
 #define FNIC_DFLT_QUEUE_DEPTH	32
 #define	FNIC_STATS_RATE_LIMIT	4 /* limit rate at which stats are pulled up */
-
+#define FNIC_MAX_CMD_LEN        16 /* Supported CDB length */
 /*
  * Tag bits used for special requests.
  */
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 71c7bbe..b0d425a 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -560,6 +560,7 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	}
 	host->max_lun = fnic->config.luns_per_tgt;
 	host->max_id = FNIC_MAX_FCP_TARGET;
+	host->max_cmd_len = FNIC_MAX_CMD_LEN;
 
 	fnic_get_res_counts(fnic);
 

