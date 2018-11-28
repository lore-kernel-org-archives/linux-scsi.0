From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 31/41] scsi: mpt3sas: mpt3sas_scsih: Mark expected switch
 fall-through
Date: Tue, 27 Nov 2018 22:32:42 -0600
Message-ID: <892c3e5e27213c1c2f3da128afe958429bbef672.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 1475400 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 5b9806d0719e..920b80ce4748 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10370,6 +10370,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		case MPI26_MFGPAGE_DEVID_CFG_SEC_3916:
 			dev_info(&pdev->dev,
 			    "HBA is in Configurable Secure mode\n");
+			/* fall through */
 		case MPI26_MFGPAGE_DEVID_SAS3508:
 		case MPI26_MFGPAGE_DEVID_SAS3508_1:
 		case MPI26_MFGPAGE_DEVID_SAS3408:
-- 
2.17.1
