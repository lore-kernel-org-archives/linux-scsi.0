From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 09/10] mpt3sas: Adding support for SAS3616 HBA device
Date: Tue, 10 Oct 2017 18:41:22 +0530
Message-ID: <1507641083-20207-10-git-send-email-Sreekanth.Reddy@broadcom.com>
References: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Adding PNP ID of Mercator i.e. SAS3616 HBA device.
Its device ID is 0xD1 and vendor ID is 0x1000.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index b819914..3f640ba 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -8808,6 +8808,7 @@ _scsih_determine_hba_mpi_version(struct pci_dev *pdev)
 	case MPI26_MFGPAGE_DEVID_SAS3516:
 	case MPI26_MFGPAGE_DEVID_SAS3516_1:
 	case MPI26_MFGPAGE_DEVID_SAS3416:
+	case MPI26_MFGPAGE_DEVID_SAS3616:
 		return MPI26_VERSION;
 	}
 	return 0;
@@ -8885,6 +8886,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		case MPI26_MFGPAGE_DEVID_SAS3516:
 		case MPI26_MFGPAGE_DEVID_SAS3516_1:
 		case MPI26_MFGPAGE_DEVID_SAS3416:
+		case MPI26_MFGPAGE_DEVID_SAS3616:
 			ioc->is_gen35_ioc = 1;
 			break;
 		default:
@@ -9341,6 +9343,9 @@ static const struct pci_device_id mpt3sas_pci_table[] = {
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_SAS3416,
 		PCI_ANY_ID, PCI_ANY_ID },
+	/* Mercator ~ 3616*/
+	{ MPI2_MFGPAGE_VENDORID_LSI, MPI26_MFGPAGE_DEVID_SAS3616,
+		PCI_ANY_ID, PCI_ANY_ID },
 	{0}     /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, mpt3sas_pci_table);
-- 
2.4.3
