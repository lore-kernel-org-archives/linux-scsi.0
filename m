From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 RESEND 19/23] pmcraid: Get rid of a redundant assignment
Date: Wed, 16 Jul 2014 20:05:23 +0200
Message-ID: <d37c53e35c578fd819d1faad176b109f8d397855.1405533479.git.agordeev@redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1405533479.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/pmcraid.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index be8ce54..c06af7f 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4746,7 +4746,6 @@ pmcraid_isr_legacy:
 	pinstance->hrrq_vector[0].drv_inst = pinstance;
 	pinstance->hrrq_vector[0].vector = pdev->irq;
 	pinstance->num_hrrq = 1;
-	rc = 0;
 
 	rc = request_irq(pdev->irq, pmcraid_isr, IRQF_SHARED,
 			 PMCRAID_DRIVER_NAME, &pinstance->hrrq_vector[0]);
-- 
1.7.7.6
