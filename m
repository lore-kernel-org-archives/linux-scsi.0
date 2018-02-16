From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v4 05/13] lpfc: Add PCI Ids for if_type=6 hardware
Date: Fri, 16 Feb 2018 09:28:19 -0800
Message-ID: <20180216172827.3739-6-jsmart2021@gmail.com>
References: <20180216172827.3739-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:38073 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161052AbeBPRbg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Feb 2018 12:31:36 -0500
Received: by mail-pl0-f67.google.com with SMTP id h10so2028860plt.5
        for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2018 09:31:36 -0800 (PST)
In-Reply-To: <20180216172827.3739-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Add PCI ids for the new G7 adapter

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

---
v3:
  Add default adapter id string for G7 adapter
---
 drivers/scsi/lpfc/lpfc_hw.h   | 1 +
 drivers/scsi/lpfc/lpfc_ids.h  | 2 ++
 drivers/scsi/lpfc/lpfc_init.c | 3 +++
 3 files changed, 6 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index bdc1f184f67a..d07d2fcbea34 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1580,6 +1580,7 @@ struct lpfc_fdmi_reg_portattr {
 #define PCI_DEVICE_ID_LANCER_FCOE   0xe260
 #define PCI_DEVICE_ID_LANCER_FCOE_VF 0xe268
 #define PCI_DEVICE_ID_LANCER_G6_FC  0xe300
+#define PCI_DEVICE_ID_LANCER_G7_FC  0xf400
 #define PCI_DEVICE_ID_SAT_SMB       0xf011
 #define PCI_DEVICE_ID_SAT_MID       0xf015
 #define PCI_DEVICE_ID_RFLY          0xf095
diff --git a/drivers/scsi/lpfc/lpfc_ids.h b/drivers/scsi/lpfc/lpfc_ids.h
index 0ba3733eb36d..329c8d28869c 100644
--- a/drivers/scsi/lpfc/lpfc_ids.h
+++ b/drivers/scsi/lpfc/lpfc_ids.h
@@ -116,6 +116,8 @@ const struct pci_device_id lpfc_id_table[] = {
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_G6_FC,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_G7_FC,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK_VF,
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 5f0c63bb0a4d..2e723cdd2c1a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2473,6 +2473,9 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 	case PCI_DEVICE_ID_LANCER_G6_FC:
 		m = (typeof(m)){"LPe32000", "PCIe", "Fibre Channel Adapter"};
 		break;
+	case PCI_DEVICE_ID_LANCER_G7_FC:
+		m = (typeof(m)){"LPe36000", "PCIe", "Fibre Channel Adapter"};
+		break;
 	case PCI_DEVICE_ID_SKYHAWK:
 	case PCI_DEVICE_ID_SKYHAWK_VF:
 		oneConnect = 1;
-- 
2.13.1
