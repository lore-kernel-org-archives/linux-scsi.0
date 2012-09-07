From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 3/4] scsi: make pci error handlers const
Date: Fri, 07 Sep 2012 09:33:16 -0700
Message-ID: <20120907163438.026331954@vyatta.com>
References: <20120907163313.614852012@vyatta.com>
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline; filename=pci-errhandle-scsi.patch
Sender: linux-pci-owner@vger.kernel.org
To: Linas Vepstas <linasvepstas@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


---
Depends on first patch that changes PCI core.

 drivers/scsi/ipr.c                   |    2 +-
 drivers/scsi/lpfc/lpfc_init.c        |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    2 +-
 drivers/scsi/qla2xxx/qla_os.c        |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c        |    2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c  |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/scsi/ipr.c	2012-09-07 09:21:37.154557681 -0700
+++ b/drivers/scsi/ipr.c	2012-09-07 09:27:25.495059297 -0700
@@ -9228,7 +9228,7 @@ static struct pci_device_id ipr_pci_tabl
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
 
-static struct pci_error_handlers ipr_err_handler = {
+static const struct pci_error_handlers ipr_err_handler = {
 	.error_detected = ipr_pci_error_detected,
 	.slot_reset = ipr_pci_slot_reset,
 };
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-09-07 09:21:37.154557681 -0700
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-09-07 09:27:25.499059257 -0700
@@ -10425,7 +10425,7 @@ static struct pci_device_id lpfc_id_tabl
 
 MODULE_DEVICE_TABLE(pci, lpfc_id_table);
 
-static struct pci_error_handlers lpfc_err_handler = {
+static const struct pci_error_handlers lpfc_err_handler = {
 	.error_detected = lpfc_io_error_detected,
 	.slot_reset = lpfc_io_slot_reset,
 	.resume = lpfc_io_resume,
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2012-09-07 09:21:37.154557681 -0700
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2012-09-07 09:27:25.499059257 -0700
@@ -8306,7 +8306,7 @@ _scsih_pci_mmio_enabled(struct pci_dev *
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
-static struct pci_error_handlers _scsih_err_handler = {
+static const struct pci_error_handlers _scsih_err_handler = {
 	.error_detected = _scsih_pci_error_detected,
 	.mmio_enabled = _scsih_pci_mmio_enabled,
 	.slot_reset =	_scsih_pci_slot_reset,
--- a/drivers/scsi/qla2xxx/qla_os.c	2012-09-07 09:21:37.154557681 -0700
+++ b/drivers/scsi/qla2xxx/qla_os.c	2012-09-07 09:27:25.499059257 -0700
@@ -4471,7 +4471,7 @@ qla2xxx_pci_resume(struct pci_dev *pdev)
 	ha->flags.eeh_busy = 0;
 }
 
-static struct pci_error_handlers qla2xxx_err_handler = {
+static const struct pci_error_handlers qla2xxx_err_handler = {
 	.error_detected = qla2xxx_pci_error_detected,
 	.mmio_enabled = qla2xxx_pci_mmio_enabled,
 	.slot_reset = qla2xxx_pci_slot_reset,
--- a/drivers/scsi/qla4xxx/ql4_os.c	2012-09-07 09:21:37.154557681 -0700
+++ b/drivers/scsi/qla4xxx/ql4_os.c	2012-09-07 09:27:25.503059217 -0700
@@ -6148,7 +6148,7 @@ qla4xxx_pci_resume(struct pci_dev *pdev)
 	clear_bit(AF_EEH_BUSY, &ha->flags);
 }
 
-static struct pci_error_handlers qla4xxx_err_handler = {
+static const struct pci_error_handlers qla4xxx_err_handler = {
 	.error_detected = qla4xxx_pci_error_detected,
 	.mmio_enabled = qla4xxx_pci_mmio_enabled,
 	.slot_reset = qla4xxx_pci_slot_reset,
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c	2012-09-07 09:21:37.154557681 -0700
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c	2012-09-07 09:27:25.503059217 -0700
@@ -2117,7 +2117,7 @@ static struct pci_device_id sym2_id_tabl
 
 MODULE_DEVICE_TABLE(pci, sym2_id_table);
 
-static struct pci_error_handlers sym2_err_handler = {
+static const struct pci_error_handlers sym2_err_handler = {
 	.error_detected	= sym2_io_error_detected,
 	.mmio_enabled	= sym2_io_slot_dump,
 	.slot_reset	= sym2_io_slot_reset,
