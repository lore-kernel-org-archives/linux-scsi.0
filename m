From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] gdth: Fixup section annotations
Date: Fri, 10 Jan 2014 16:31:28 +0100
Message-ID: <1389367888-117607-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbaAJPbb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jan 2014 10:31:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Fixup section annotations so that kbuild doesn't complain anymore.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/gdth.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index ce5ef01..98bd66e 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -329,7 +329,7 @@ static int irq[MAXHA] __initdata =
 {0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff,
  0xff,0xff,0xff,0xff,0xff,0xff,0xff,0xff};
 /* disable driver flag */
-static int disable __initdata = 0;
+static int disable = 0;
 /* reserve flag */
 static int reserve_mode = 1;                  
 /* reserve list */
@@ -658,7 +658,7 @@ static int gdth_pci_init_one(struct pci_dev *pdev,
 #endif /* CONFIG_PCI */
 
 #ifdef CONFIG_EISA
-static int __init gdth_init_eisa(u16 eisa_adr,gdth_ha_str *ha)
+static int __devinit gdth_init_eisa(u16 eisa_adr,gdth_ha_str *ha)
 {
     u32 retries,id;
     u8 prot_ver,eisacf,i,irq_found;
@@ -752,7 +752,7 @@ static int __init gdth_init_eisa(u16 eisa_adr,gdth_ha_str *ha)
 #endif /* CONFIG_EISA */
 
 #ifdef CONFIG_ISA
-static int __init gdth_init_isa(u32 bios_adr,gdth_ha_str *ha)
+static int __devinit gdth_init_isa(u32 bios_adr,gdth_ha_str *ha)
 {
     register gdt2_dpram_str __iomem *dp2_ptr;
     int i;
@@ -4688,7 +4688,7 @@ static struct scsi_host_template gdth_template = {
 };
 
 #ifdef CONFIG_ISA
-static int __init gdth_isa_probe_one(u32 isa_bios)
+static int __devinit gdth_isa_probe_one(u32 isa_bios)
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
@@ -4820,7 +4820,7 @@ static int __init gdth_isa_probe_one(u32 isa_bios)
 #endif /* CONFIG_ISA */
 
 #ifdef CONFIG_EISA
-static int __init gdth_eisa_probe_one(u16 eisa_slot)
+static int __devinit gdth_eisa_probe_one(u16 eisa_slot)
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
@@ -5155,7 +5155,7 @@ static struct notifier_block gdth_notifier = {
     gdth_halt, NULL, 0
 };
 
-static int __init gdth_init(void)
+static int __devinit gdth_init(void)
 {
 	if (disable) {
 		printk("GDT-HA: Controller driver disabled from"
@@ -5209,7 +5209,7 @@ static int __init gdth_init(void)
 	return 0;
 }
 
-static void __exit gdth_exit(void)
+static void __devexit gdth_exit(void)
 {
 	gdth_ha_str *ha;
 
-- 
1.7.12.4

