From: Joe Perches <joe@perches.com>
Subject: [PATCH 1/3] BusLogic: Add __printf verification, fix fallout
Date: Thu, 16 May 2013 21:58:30 -0700
Message-ID: <0424edbf1b8d1c432565ff5315d5c694a416fe0e.1368765873.git.joe@perches.com>
References: <cover.1368754556.git.khalid.aziz@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1368754556.git.khalid.aziz@oracle.com>
In-Reply-To: <cover.1368765873.git.joe@perches.com>
References: <cover.1368765873.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Make format and arguments match.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/BusLogic.c | 50 ++++++++++++++++++++++++-------------------------
 drivers/scsi/BusLogic.h |  1 +
 2 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index feab3a5..28c2051 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -720,23 +720,23 @@ static int __init blogic_init_mm_probeinfo(struct blogic_adapter *adapter)
 		pci_addr = base_addr1 = pci_resource_start(pci_device, 1);
 
 		if (pci_resource_flags(pci_device, 0) & IORESOURCE_MEM) {
-			blogic_err("BusLogic: Base Address0 0x%X not I/O for " "MultiMaster Host Adapter\n", NULL, base_addr0);
-			blogic_err("at PCI Bus %d Device %d I/O Address 0x%X\n", NULL, bus, device, io_addr);
+			blogic_err("BusLogic: Base Address0 0x%lX not I/O for " "MultiMaster Host Adapter\n", NULL, base_addr0);
+			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
 			continue;
 		}
 		if (pci_resource_flags(pci_device, 1) & IORESOURCE_IO) {
-			blogic_err("BusLogic: Base Address1 0x%X not Memory for " "MultiMaster Host Adapter\n", NULL, base_addr1);
-			blogic_err("at PCI Bus %d Device %d PCI Address 0x%X\n", NULL, bus, device, pci_addr);
+			blogic_err("BusLogic: Base Address1 0x%lX not Memory for " "MultiMaster Host Adapter\n", NULL, base_addr1);
+			blogic_err("at PCI Bus %d Device %d PCI Address 0x%lX\n", NULL, bus, device, pci_addr);
 			continue;
 		}
 		if (irq_ch == 0) {
 			blogic_err("BusLogic: IRQ Channel %d invalid for " "MultiMaster Host Adapter\n", NULL, irq_ch);
-			blogic_err("at PCI Bus %d Device %d I/O Address 0x%X\n", NULL, bus, device, io_addr);
+			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
 			continue;
 		}
 		if (blogic_global_options.trace_probe) {
 			blogic_notice("BusLogic: PCI MultiMaster Host Adapter " "detected at\n", NULL);
-			blogic_notice("BusLogic: PCI Bus %d Device %d I/O Address " "0x%X PCI Address 0x%X\n", NULL, bus, device, io_addr, pci_addr);
+			blogic_notice("BusLogic: PCI Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX\n", NULL, bus, device, io_addr, pci_addr);
 		}
 		/*
 		   Issue the Inquire PCI Host Adapter Information command to determine
@@ -960,23 +960,23 @@ static int __init blogic_init_fp_probeinfo(struct blogic_adapter *adapter)
 		pci_addr = base_addr1 = pci_resource_start(pci_device, 1);
 #ifdef CONFIG_SCSI_FLASHPOINT
 		if (pci_resource_flags(pci_device, 0) & IORESOURCE_MEM) {
-			blogic_err("BusLogic: Base Address0 0x%X not I/O for " "FlashPoint Host Adapter\n", NULL, base_addr0);
-			blogic_err("at PCI Bus %d Device %d I/O Address 0x%X\n", NULL, bus, device, io_addr);
+			blogic_err("BusLogic: Base Address0 0x%lX not I/O for " "FlashPoint Host Adapter\n", NULL, base_addr0);
+			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
 			continue;
 		}
 		if (pci_resource_flags(pci_device, 1) & IORESOURCE_IO) {
-			blogic_err("BusLogic: Base Address1 0x%X not Memory for " "FlashPoint Host Adapter\n", NULL, base_addr1);
-			blogic_err("at PCI Bus %d Device %d PCI Address 0x%X\n", NULL, bus, device, pci_addr);
+			blogic_err("BusLogic: Base Address1 0x%lX not Memory for " "FlashPoint Host Adapter\n", NULL, base_addr1);
+			blogic_err("at PCI Bus %d Device %d PCI Address 0x%lX\n", NULL, bus, device, pci_addr);
 			continue;
 		}
 		if (irq_ch == 0) {
 			blogic_err("BusLogic: IRQ Channel %d invalid for " "FlashPoint Host Adapter\n", NULL, irq_ch);
-			blogic_err("at PCI Bus %d Device %d I/O Address 0x%X\n", NULL, bus, device, io_addr);
+			blogic_err("at PCI Bus %d Device %d I/O Address 0x%lX\n", NULL, bus, device, io_addr);
 			continue;
 		}
 		if (blogic_global_options.trace_probe) {
 			blogic_notice("BusLogic: FlashPoint Host Adapter " "detected at\n", NULL);
-			blogic_notice("BusLogic: PCI Bus %d Device %d I/O Address " "0x%X PCI Address 0x%X\n", NULL, bus, device, io_addr, pci_addr);
+			blogic_notice("BusLogic: PCI Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX\n", NULL, bus, device, io_addr, pci_addr);
 		}
 		if (blogic_probeinfo_count < BLOGIC_MAX_ADAPTERS) {
 			struct blogic_probeinfo *probeinfo =
@@ -1103,9 +1103,9 @@ static bool blogic_failure(struct blogic_adapter *adapter, char *msg)
 	if (adapter->adapter_bus_type == BLOGIC_PCI_BUS) {
 		blogic_err("While configuring BusLogic PCI Host Adapter at\n",
 				adapter);
-		blogic_err("Bus %d Device %d I/O Address 0x%X PCI Address 0x%X:\n", adapter, adapter->bus, adapter->dev, adapter->io_addr, adapter->pci_addr);
+		blogic_err("Bus %d Device %d I/O Address 0x%lX PCI Address 0x%lX:\n", adapter, adapter->bus, adapter->dev, adapter->io_addr, adapter->pci_addr);
 	} else
-		blogic_err("While configuring BusLogic Host Adapter at " "I/O Address 0x%X:\n", adapter, adapter->io_addr);
+		blogic_err("While configuring BusLogic Host Adapter at I/O Address 0x%lX:\n", adapter, adapter->io_addr);
 	blogic_err("%s FAILED - DETACHING\n", adapter, msg);
 	if (blogic_cmd_failure_reason != NULL)
 		blogic_err("ADDITIONAL FAILURE INFO - %s\n", adapter,
@@ -1133,13 +1133,13 @@ static bool __init blogic_probe(struct blogic_adapter *adapter)
 		fpinfo->present = false;
 		if (!(FlashPoint_ProbeHostAdapter(fpinfo) == 0 &&
 					fpinfo->present)) {
-			blogic_err("BusLogic: FlashPoint Host Adapter detected at " "PCI Bus %d Device %d\n", adapter, adapter->bus, adapter->dev);
-			blogic_err("BusLogic: I/O Address 0x%X PCI Address 0x%X, " "but FlashPoint\n", adapter, adapter->io_addr, adapter->pci_addr);
+			blogic_err("BusLogic: FlashPoint Host Adapter detected at PCI Bus %d Device %d\n", adapter, adapter->bus, adapter->dev);
+			blogic_err("BusLogic: I/O Address 0x%lX PCI Address 0x%lX, but FlashPoint\n", adapter, adapter->io_addr, adapter->pci_addr);
 			blogic_err("BusLogic: Probe Function failed to validate it.\n", adapter);
 			return false;
 		}
 		if (blogic_global_options.trace_probe)
-			blogic_notice("BusLogic_Probe(0x%X): FlashPoint Found\n", adapter, adapter->io_addr);
+			blogic_notice("BusLogic_Probe(0x%lX): FlashPoint Found\n", adapter, adapter->io_addr);
 		/*
 		   Indicate the Host Adapter Probe completed successfully.
 		 */
@@ -1156,7 +1156,7 @@ static bool __init blogic_probe(struct blogic_adapter *adapter)
 	intreg.all = blogic_rdint(adapter);
 	georeg.all = blogic_rdgeom(adapter);
 	if (blogic_global_options.trace_probe)
-		blogic_notice("BusLogic_Probe(0x%X): Status 0x%02X, Interrupt 0x%02X, " "Geometry 0x%02X\n", adapter, adapter->io_addr, statusreg.all, intreg.all, georeg.all);
+		blogic_notice("BusLogic_Probe(0x%lX): Status 0x%02X, Interrupt 0x%02X, Geometry 0x%02X\n", adapter, adapter->io_addr, statusreg.all, intreg.all, georeg.all);
 	if (statusreg.all == 0 || statusreg.sr.diag_active ||
 			statusreg.sr.cmd_param_busy || statusreg.sr.rsvd ||
 			statusreg.sr.cmd_invalid || intreg.ir.rsvd != 0)
@@ -1235,7 +1235,7 @@ static bool blogic_hwreset(struct blogic_adapter *adapter, bool hard_reset)
 		udelay(100);
 	}
 	if (blogic_global_options.trace_hw_reset)
-		blogic_notice("BusLogic_HardwareReset(0x%X): Diagnostic Active, " "Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
+		blogic_notice("BusLogic_HardwareReset(0x%lX): Diagnostic Active, Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
 	if (timeout < 0)
 		return false;
 	/*
@@ -1255,7 +1255,7 @@ static bool blogic_hwreset(struct blogic_adapter *adapter, bool hard_reset)
 		udelay(100);
 	}
 	if (blogic_global_options.trace_hw_reset)
-		blogic_notice("BusLogic_HardwareReset(0x%X): Diagnostic Completed, " "Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
+		blogic_notice("BusLogic_HardwareReset(0x%lX): Diagnostic Completed, Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
 	if (timeout < 0)
 		return false;
 	/*
@@ -1271,7 +1271,7 @@ static bool blogic_hwreset(struct blogic_adapter *adapter, bool hard_reset)
 		udelay(100);
 	}
 	if (blogic_global_options.trace_hw_reset)
-		blogic_notice("BusLogic_HardwareReset(0x%X): Host Adapter Ready, " "Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
+		blogic_notice("BusLogic_HardwareReset(0x%lX): Host Adapter Ready, Status 0x%02X\n", adapter, adapter->io_addr, statusreg.all);
 	if (timeout < 0)
 		return false;
 	/*
@@ -1327,7 +1327,7 @@ static bool __init blogic_checkadapter(struct blogic_adapter *adapter)
 	   Provide tracing information if requested and return.
 	 */
 	if (blogic_global_options.trace_probe)
-		blogic_notice("BusLogic_Check(0x%X): MultiMaster %s\n", adapter,
+		blogic_notice("BusLogic_Check(0x%lX): MultiMaster %s\n", adapter,
 				adapter->io_addr,
 				(result ? "Found" : "Not Found"));
 	return result;
@@ -1840,7 +1840,7 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
 	int tgt_id;
 
 	blogic_info("Configuring BusLogic Model %s %s%s%s%s SCSI Host Adapter\n", adapter, adapter->model, blogic_adapter_busnames[adapter->adapter_bus_type], (adapter->wide ? " Wide" : ""), (adapter->differential ? " Differential" : ""), (adapter->ultra ? " Ultra" : ""));
-	blogic_info("  Firmware Version: %s, I/O Address: 0x%X, " "IRQ Channel: %d/%s\n", adapter, adapter->fw_ver, adapter->io_addr, adapter->irq_ch, (adapter->level_int ? "Level" : "Edge"));
+	blogic_info("  Firmware Version: %s, I/O Address: 0x%lX, IRQ Channel: %d/%s\n", adapter, adapter->fw_ver, adapter->io_addr, adapter->irq_ch, (adapter->level_int ? "Level" : "Edge"));
 	if (adapter->adapter_bus_type != BLOGIC_PCI_BUS) {
 		blogic_info("  DMA Channel: ", adapter);
 		if (adapter->dma_ch > 0)
@@ -1856,7 +1856,7 @@ static bool __init blogic_reportconfig(struct blogic_adapter *adapter)
 		blogic_info("  PCI Bus: %d, Device: %d, Address: ", adapter,
 				adapter->bus, adapter->dev);
 		if (adapter->pci_addr > 0)
-			blogic_info("0x%X, ", adapter, adapter->pci_addr);
+			blogic_info("0x%lX, ", adapter, adapter->pci_addr);
 		else
 			blogic_info("Unassigned, ", adapter);
 	}
@@ -3675,7 +3675,7 @@ static int __init blogic_parseopts(char *options)
 					blogic_probe_options.probe134 = true;
 					break;
 				default:
-					blogic_err("BusLogic: Invalid Driver Options " "(invalid I/O Address 0x%X)\n", NULL, io_addr);
+					blogic_err("BusLogic: Invalid Driver Options (invalid I/O Address 0x%lX)\n", NULL, io_addr);
 					return 0;
 				}
 			} else if (blogic_parse(&options, "NoProbeISA"))
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index b53ec2f..d06e902 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -1296,6 +1296,7 @@ static int blogic_slaveconfig(struct scsi_device *);
 static void blogic_qcompleted_ccb(struct blogic_ccb *);
 static irqreturn_t blogic_inthandler(int, void *);
 static int blogic_resetadapter(struct blogic_adapter *, bool hard_reset);
+__printf(2, 4)
 static void blogic_msg(enum blogic_msglevel, char *, struct blogic_adapter *, ...);
 static int __init blogic_setup(char *);
 
-- 
1.8.1.2.459.gbcd45b4.dirty
