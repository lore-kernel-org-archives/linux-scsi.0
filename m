From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 08/48] hpsa: Fix -Wunused-but-set-variable warning
Date: Fri, 23 Jan 2015 16:41:46 -0600
Message-ID: <20150123224145.14919.57099.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:30262 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbbAWWmj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:42:39 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

Remove unused variable in hpsa_free_cmd_pool.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Don Brace <don.brace@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index dc81d88..11d21ef 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6482,11 +6482,11 @@ static void hpsa_free_cmd_pool(struct ctlr_info *h)
 
 static void hpsa_irq_affinity_hints(struct ctlr_info *h)
 {
-	int i, cpu, rc;
+	int i, cpu;
 
 	cpu = cpumask_first(cpu_online_mask);
 	for (i = 0; i < h->msix_vector; i++) {
-		rc = irq_set_affinity_hint(h->intr[i], get_cpu_mask(cpu));
+		irq_set_affinity_hint(h->intr[i], get_cpu_mask(cpu));
 		cpu = cpumask_next(cpu, cpu_online_mask);
 	}
 }

