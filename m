From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] hpsa: remove set but unused variable rc
Date: Wed, 29 Oct 2014 16:15:04 +0100
Message-ID: <1414595704-3119-1-git-send-email-fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fix -Wunused-but-set-variable warning

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/hpsa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index cef5d49..34330e1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6619,11 +6619,11 @@ static void hpsa_free_cmd_pool(struct ctlr_info *h)
 
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
-- 
1.9.3
