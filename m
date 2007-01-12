From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [PATCH] megaraid: fix kernel-doc
Date: Fri, 12 Jan 2007 16:28:02 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E822989137F@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:52433 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161159AbXALX2d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jan 2007 18:28:33 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@Oracle.Com>, scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@osdl.org>

Thanks Randy for the patch.

Regards,

Sumant 

-----Original Message-----
From: Randy Dunlap [mailto:randy.dunlap@Oracle.Com] 
Sent: Friday, January 05, 2007 10:42 PM
To: Patro, Sumant; scsi
Cc: jejb; akpm
Subject: [PATCH] megaraid: fix kernel-doc

From: Randy Dunlap <randy.dunlap@oracle.com>

kernel-doc modifications:
- change "@param var" notation to @var;
- change function/description separator from ':' to '-';
- change var/description separator from '-' to ':';
- fix a few doc. typos;
- don't use kernel-doc /** lead-in when the doc. block is not
kernel-doc;
- use Linux common */ ending comment format instead of **/;
- use correct function parameter names;
- place function parameters immediately after the function short
description;
- place kernel-doc immediately before its function or macro;

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/megaraid/mega_common.h    |  120 ++++++-------
 drivers/scsi/megaraid/megaraid_ioctl.h |   36 ++--
 drivers/scsi/megaraid/megaraid_mbox.c  |  285
++++++++++++++++-----------------
 drivers/scsi/megaraid/megaraid_mbox.h  |   42 ++--
 drivers/scsi/megaraid/megaraid_mm.c    |   65 +++----
 drivers/scsi/megaraid/megaraid_sas.h   |   14 -
 6 files changed, 275 insertions(+), 287 deletions(-)

--- linux-2620-rc3g4.orig/drivers/scsi/megaraid/mega_common.h
+++ linux-2620-rc3g4/drivers/scsi/megaraid/mega_common.h
@@ -46,17 +46,17 @@
 
 /**
  * scb_t - scsi command control block
- * @param ccb		: command control block for individual driver
- * @param list		: list of control blocks
- * @param gp		: general purpose field for LLDs
- * @param sno		: all SCBs have a serial number
- * @param scp		: associated scsi command
- * @param state		: current state of scb
- * @param dma_dir	: direction of data transfer
- * @param dma_type	: transfer with sg list, buffer, or no data
transfer
- * @param dev_channel	: actual channel on the device
- * @param dev_target	: actual target on the device
- * @param status	: completion status
+ * @ccb			: command control block for individual
driver
+ * @list		: list of control blocks
+ * @gp			: general purpose field for LLDs
+ * @sno			: all SCBs have a serial number
+ * @scp			: associated scsi command
+ * @state		: current state of scb
+ * @dma_dir		: direction of data transfer
+ * @dma_type		: transfer with sg list, buffer, or no data
transfer
+ * @dev_channel		: actual channel on the device
+ * @dev_target		: actual target on the device
+ * @status		: completion status
  *
  * This is our central data structure to issue commands the each
driver.
  * Driver specific data structures are maintained in the ccb field.
@@ -99,42 +99,42 @@ typedef struct {
 
 /**
  * struct adapter_t - driver's initialization structure
- * @param dpc_h			: tasklet handle
- * @param pdev			: pci configuration pointer for kernel
- * @param host			: pointer to host structure of mid-layer
- * @param lock			: synchronization lock for mid-layer and
driver
- * @param quiescent		: driver is quiescent for now.
- * @param outstanding_cmds	: number of commands pending in the
driver
- * @param kscb_list		: pointer to the bulk of SCBs pointers
for IO
- * @param kscb_pool		: pool of free scbs for IO
- * @param kscb_pool_lock	: lock for pool of free scbs
- * @param pend_list		: pending commands list
- * @param pend_list_lock	: exlusion lock for pending commands
list
- * @param completed_list	: list of completed commands
- * @param completed_list_lock	: exclusion lock for list of completed
commands
- * @param sglen			: max sg elements supported
- * @param device_ids		: to convert kernel device addr to our
devices.
- * @param raid_device		: raid adapter specific pointer
- * @param max_channel		: maximum channel number supported -
inclusive
- * @param max_target		: max target supported - inclusive
- * @param max_lun		: max lun supported - inclusive
- * @param unique_id		: unique identifier for each adapter
- * @param irq			: IRQ for this adapter
- * @param ito			: internal timeout value, (-1) means no
timeout
- * @param ibuf			: buffer to issue internal commands
- * @param ibuf_dma_h		: dma handle for the above buffer
- * @param uscb_list		: SCB pointers for user cmds, common
mgmt module
- * @param uscb_pool		: pool of SCBs for user commands
- * @param uscb_pool_lock	: exclusion lock for these SCBs
- * @param max_cmds		: max outstanding commands
- * @param fw_version		: firmware version
- * @param bios_version		: bios version
- * @param max_cdb_sz		: biggest CDB size supported.
- * @param ha			: is high availability present -
clustering
- * @param init_id		: initiator ID, the default value should
be 7
- * @param max_sectors		: max sectors per request
- * @param cmd_per_lun		: max outstanding commands per LUN
- * @param being_detached	: set when unloading, no more mgmt calls
+ * @aram dpc_h			: tasklet handle
+ * @pdev			: pci configuration pointer for kernel
+ * @host			: pointer to host structure of mid-layer
+ * @lock			: synchronization lock for mid-layer and
driver
+ * @quiescent			: driver is quiescent for now.
+ * @outstanding_cmds		: number of commands pending in the
driver
+ * @kscb_list			: pointer to the bulk of SCBs pointers
for IO
+ * @kscb_pool			: pool of free scbs for IO
+ * @kscb_pool_lock		: lock for pool of free scbs
+ * @pend_list			: pending commands list
+ * @pend_list_lock		: exclusion lock for pending commands
list
+ * @completed_list		: list of completed commands
+ * @completed_list_lock		: exclusion lock for list of
completed commands
+ * @sglen			: max sg elements supported
+ * @device_ids			: to convert kernel device addr to our
devices.
+ * @raid_device			: raid adapter specific pointer
+ * @max_channel			: maximum channel number
supported - inclusive
+ * @max_target			: max target supported - inclusive
+ * @max_lun			: max lun supported - inclusive
+ * @unique_id			: unique identifier for each adapter
+ * @irq				: IRQ for this adapter
+ * @ito				: internal timeout value, (-1)
means no timeout
+ * @ibuf			: buffer to issue internal commands
+ * @ibuf_dma_h			: dma handle for the above buffer
+ * @uscb_list			: SCB pointers for user cmds, common
mgmt module
+ * @uscb_pool			: pool of SCBs for user commands
+ * @uscb_pool_lock		: exclusion lock for these SCBs
+ * @max_cmds			: max outstanding commands
+ * @fw_version			: firmware version
+ * @bios_version		: bios version
+ * @max_cdb_sz			: biggest CDB size supported.
+ * @ha				: is high availability present -
clustering
+ * @init_id			: initiator ID, the default value should
be 7
+ * @max_sectors			: max sectors per request
+ * @cmd_per_lun			: max outstanding commands per
LUN
+ * @being_detached		: set when unloading, no more mgmt calls
  *
  *
  * mraid_setup_device_map() can be called anytime after the device map
is @@ -211,23 +211,23 @@ typedef struct {
 #define SCP2ADAPTER(scp)	(adapter_t
*)SCSIHOST2ADAP(SCP2HOST(scp))
 
 
-/**
- * MRAID_GET_DEVICE_MAP - device ids
- * @param adp		- Adapter's soft state
- * @param scp		- mid-layer scsi command pointer
- * @param p_chan	- physical channel on the controller
- * @param target	- target id of the device or logical drive
number
- * @param islogical	- set if the command is for the logical drive
- *
- * Macro to retrieve information about device class, logical or
physical and
- * the corresponding physical channel and target or logical drive
number
- **/
 #define MRAID_IS_LOGICAL(adp, scp)	\
 	(SCP2CHANNEL(scp) == (adp)->max_channel) ? 1 : 0
 
 #define MRAID_IS_LOGICAL_SDEV(adp, sdev)	\
 	(sdev->channel == (adp)->max_channel) ? 1 : 0
 
+/**
+ * MRAID_GET_DEVICE_MAP - device ids
+ * @adp			: adapter's soft state
+ * @scp			: mid-layer scsi command pointer
+ * @p_chan		: physical channel on the controller
+ * @target		: target id of the device or logical drive
number
+ * @islogical		: set if the command is for the logical drive
+ *
+ * Macro to retrieve information about device class, logical or 
+physical and
+ * the corresponding physical channel and target or logical drive 
+number  */
 #define MRAID_GET_DEVICE_MAP(adp, scp, p_chan, target, islogical)
\
 	/*
\
 	 * Is the request coming for the virtual channel
\
@@ -273,8 +273,8 @@ typedef struct {
 
 /*
  * struct mraid_pci_blk - structure holds DMA memory block info
- * @param vaddr		: virtual address to a memory block
- * @param dma_addr	: DMA handle to a memory block
+ * @vaddr		: virtual address to a memory block
+ * @dma_addr		: DMA handle to a memory block
  *
  * This structure is filled up for the caller. It is the responsibilty
of the
  * caller to allocate this array big enough to store addresses for all
--- linux-2620-rc3g4.orig/drivers/scsi/megaraid/megaraid_ioctl.h
+++ linux-2620-rc3g4/drivers/scsi/megaraid/megaraid_ioctl.h
@@ -22,23 +22,23 @@
 
 #include "mbox_defs.h"
 
+/*
+ * console messages debug levels
+ */
+#define	CL_ANN		0	/* print unconditionally,
announcements */
+#define CL_DLEVEL1	1	/* debug level 1, informative */
+#define CL_DLEVEL2	2	/* debug level 2, verbose */
+#define CL_DLEVEL3	3	/* debug level 3, very verbose */
+
 /**
  * con_log() - console log routine
- * @param level		: indicates the severity of the message.
- * @fparam mt		: format string
+ * @level		: indicates the severity of the message.
+ * @fmt			: format string
  *
  * con_log displays the error messages on the console based on the
current
  * debug level. Also it attaches the appropriate kernel severity level
with
  * the message.
- *
- *
- * consolge messages debug levels
  */
-#define	CL_ANN		0	/* print unconditionally,
announcements */
-#define CL_DLEVEL1	1	/* debug level 1, informative */
-#define CL_DLEVEL2	2	/* debug level 2, verbose */
-#define CL_DLEVEL3	3	/* debug level 3, very verbose */
-
 #define	con_log(level, fmt) if (LSI_DBGLVL >= level) printk fmt;
 
 /*
@@ -157,14 +157,14 @@ typedef struct uioc {
 /**
  * struct mraid_hba_info - information about the controller
  *
- * @param pci_vendor_id		: PCI vendor id
- * @param pci_device_id		: PCI device id
- * @param subsystem_vendor_id	: PCI subsystem vendor id
- * @param subsystem_device_id	: PCI subsystem device id
- * @param baseport		: base port of hba memory
- * @param pci_bus		: PCI bus
- * @param pci_dev_fn		: PCI device/function values
- * @param irq			: interrupt vector for the device
+ * @pci_vendor_id		: PCI vendor id
+ * @pci_device_id		: PCI device id
+ * @subsystem_vendor_id		: PCI subsystem vendor id
+ * @subsystem_device_id		: PCI subsystem device id
+ * @baseport			: base port of hba memory
+ * @pci_bus			: PCI bus
+ * @pci_dev_fn			: PCI device/function values
+ * @irq				: interrupt vector for the
device
  *
  * Extended information of 256 bytes about the controller. Align on the
single
  * byte boundary so that 32-bit applications can be run on 64-bit
platform
--- linux-2620-rc3g4.orig/drivers/scsi/megaraid/megaraid_mbox.h
+++ linux-2620-rc3g4/drivers/scsi/megaraid/megaraid_mbox.h
@@ -146,27 +146,27 @@ typedef struct {
 
 /**
  * mraid_device_t - adapter soft state structure for mailbox
controllers
- * @param una_mbox64		: 64-bit mbox - unaligned
- * @param una_mbox64_dma	: mbox dma addr - unaligned
- * @param mbox			: 32-bit mbox - aligned
- * @param mbox64		: 64-bit mbox - aligned
- * @param mbox_dma		: mbox dma addr - aligned
- * @param mailbox_lock		: exclusion lock for the mailbox
- * @param baseport		: base port of hba memory
- * @param baseaddr		: mapped addr of hba memory
- * @param mbox_pool		: pool of mailboxes
- * @param mbox_pool_handle	: handle for the mailbox pool memory
- * @param epthru_pool		: a pool for extended passthru commands
- * @param epthru_pool_handle	: handle to the pool above
- * @param sg_pool		: pool of scatter-gather lists for this
driver
- * @param sg_pool_handle	: handle to the pool above
- * @param ccb_list		: list of our command control blocks
- * @param uccb_list		: list of cmd control blocks for mgmt
module
- * @param umbox64		: array of mailbox for user commands
(cmm)
- * @param pdrv_state		: array for state of each physical
drive.
- * @param last_disp		: flag used to show device scanning
- * @param hw_error		: set if FW not responding
- * @param fast_load		: If set, skip physical device scanning
+ * @una_mbox64			: 64-bit mbox - unaligned
+ * @una_mbox64_dma		: mbox dma addr - unaligned
+ * @mbox			: 32-bit mbox - aligned
+ * @mbox64			: 64-bit mbox - aligned
+ * @mbox_dma			: mbox dma addr - aligned
+ * @mailbox_lock		: exclusion lock for the mailbox
+ * @baseport			: base port of hba memory
+ * @baseaddr			: mapped addr of hba memory
+ * @mbox_pool			: pool of mailboxes
+ * @mbox_pool_handle		: handle for the mailbox pool memory
+ * @epthru_pool			: a pool for extended passthru
commands
+ * @epthru_pool_handle		: handle to the pool above
+ * @sg_pool			: pool of scatter-gather lists for this
driver
+ * @sg_pool_handle		: handle to the pool above
+ * @ccb_list			: list of our command control blocks
+ * @uccb_list			: list of cmd control blocks for mgmt
module
+ * @umbox64			: array of mailbox for user commands
(cmm)
+ * @pdrv_state			: array for state of each physical
drive.
+ * @last_disp			: flag used to show device scanning
+ * @hw_error			: set if FW not responding
+ * @fast_load			: If set, skip physical device scanning
  * @channel_class		: channel class, RAID or SCSI
  * @sysfs_sem			: semaphore to serialize access to sysfs
res.
  * @sysfs_uioc			: management packet to issue FW calls
from sysfs
--- linux-2620-rc3g4.orig/drivers/scsi/megaraid/megaraid_mbox.c
+++ linux-2620-rc3g4/drivers/scsi/megaraid/megaraid_mbox.c
@@ -147,7 +147,7 @@ MODULE_VERSION(MEGARAID_VERSION);
  * ### modules parameters for driver ###
  */
 
-/**
+/*
  * Set to enable driver to expose unconfigured disk to kernel
  */
 static int megaraid_expose_unconf_disks = 0; @@ -155,7 +155,7 @@
module_param_named(unconf_disks, megarai  MODULE_PARM_DESC(unconf_disks,
 	"Set to expose unconfigured disks to kernel (default=0)");
 
-/**
+/*
  * driver wait time if the adapter's mailbox is busy
  */
 static unsigned int max_mbox_busy_wait = MBOX_BUSY_WAIT; @@ -163,7
+163,7 @@ module_param_named(busy_wait, max_mbox_b
MODULE_PARM_DESC(busy_wait,
 	"Max wait for mailbox in microseconds if busy (default=10)");
 
-/**
+/*
  * number of sectors per IO command
  */
 static unsigned int megaraid_max_sectors = MBOX_MAX_SECTORS; @@ -171,7
+171,7 @@ module_param_named(max_sectors, megaraid
MODULE_PARM_DESC(max_sectors,
 	"Maximum number of sectors per IO command (default=128)");
 
-/**
+/*
  * number of commands per logical unit
  */
 static unsigned int megaraid_cmd_per_lun = MBOX_DEF_CMD_PER_LUN; @@
-180,7 +180,7 @@ MODULE_PARM_DESC(cmd_per_lun,
 	"Maximum number of commands per logical unit (default=64)");
 
 
-/**
+/*
  * Fast driver load option, skip scanning for physical devices during
load.
  * This would result in non-disk devices being skipped during driver
load
  * time. These can be later added though, using /proc/scsi/scsi @@
-191,7 +191,7 @@ MODULE_PARM_DESC(fast_load,
 	"Faster loading of the driver, skips physical devices!
(default=0)");
 
 
-/**
+/*
  * mraid_debug level - threshold for amount of information to be
displayed by
  * the driver. This level can be changed through modules parameters,
ioctl or
  * sysfs/proc interface. By default, print the announcement messages
only.
@@ -338,7 +338,7 @@ static struct device_attribute *megaraid
  *
  * Return value:
  * 	actual depth set
- **/
+ */
 static int megaraid_change_queue_depth(struct scsi_device *sdev, int
qdepth)  {
 	if (qdepth > MBOX_MAX_SCSI_CMDS)
@@ -370,8 +370,8 @@ static struct scsi_host_template megarai
  * megaraid_init - module load hook
  *
  * We register ourselves as hotplug enabled module and let PCI
subsystem
- * discover our adaters
- **/
+ * discover our adapters.
+ */
 static int __init
 megaraid_init(void)
 {
@@ -406,7 +406,7 @@ megaraid_init(void)
 /**
  * megaraid_exit - driver unload entry point
  *
- * We simply unwrap the megaraid_init routine here
+ * We simply unwrap the megaraid_init routine here.
  */
 static void __exit
 megaraid_exit(void)
@@ -422,12 +422,12 @@ megaraid_exit(void)
 
 /**
  * megaraid_probe_one - PCI hotplug entry point
- * @param pdev	: handle to this controller's PCI configuration space
- * @param id	: pci device id of the class of controllers
+ * @pdev	: handle to this controller's PCI configuration space
+ * @id		: pci device id of the class of controllers
  *
  * This routine should be called whenever a new adapter is detected by
the
  * PCI hotplug susbsytem.
- **/
+ */
 static int __devinit
 megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id
*id)  { @@ -543,16 +543,15 @@ out_probe_one:
 
 
 /**
- * megaraid_detach_one - release the framework resources and call LLD
release
- * routine
- * @param pdev	: handle for our PCI cofiguration space
+ * megaraid_detach_one - release framework resources and call LLD
release routine
+ * @pdev	: handle for our PCI cofiguration space
  *
  * This routine is called during driver unload. We free all the
allocated
  * resources and call the corresponding LLD so that it can also release
all
  * its resources.
  *
- * This routine is also called from the PCI hotplug system
- **/
+ * This routine is also called from the PCI hotplug system.
+ */
 static void
 megaraid_detach_one(struct pci_dev *pdev)  { @@ -616,9 +615,9 @@
megaraid_detach_one(struct pci_dev *pdev
 
 /**
  * megaraid_mbox_shutdown - PCI shutdown for megaraid HBA
- * @param device	: generice driver model device
+ * @pdev		: generic driver model device
  *
- * Shutdown notification, perform flush cache
+ * Shutdown notification, perform flush cache.
  */
 static void
 megaraid_mbox_shutdown(struct pci_dev *pdev) @@ -644,10 +643,10 @@
megaraid_mbox_shutdown(struct pci_dev *p
 
 /**
  * megaraid_io_attach - attach a device with the IO subsystem
- * @param adapter	: controller's soft state
+ * @adapter		: controller's soft state
  *
- * Attach this device with the IO subsystem
- **/
+ * Attach this device with the IO subsystem.
+ */
 static int
 megaraid_io_attach(adapter_t *adapter)
 {
@@ -696,10 +695,10 @@ megaraid_io_attach(adapter_t *adapter)
 
 /**
  * megaraid_io_detach - detach a device from the IO subsystem
- * @param adapter	: controller's soft state
+ * @adapter		: controller's soft state
  *
- * Detach this device from the IO subsystem
- **/
+ * Detach this device from the IO subsystem.
+ */
 static void
 megaraid_io_detach(adapter_t *adapter)
 {
@@ -723,13 +722,13 @@ megaraid_io_detach(adapter_t *adapter)
 
 /**
  * megaraid_init_mbox - initialize controller
- * @param adapter	- our soft state
+ * @adapter		: our soft state
  *
- * . Allocate 16-byte aligned mailbox memory for firmware handshake
- * . Allocate controller's memory resources
- * . Find out all initialization data
- * . Allocate memory required for all the commands
- * . Use internal library of FW routines, build up complete soft state
+ * - Allocate 16-byte aligned mailbox memory for firmware handshake
+ * - Allocate controller's memory resources
+ * - Find out all initialization data
+ * - Allocate memory required for all the commands
+ * - Use internal library of FW routines, build up complete soft state
  */
 static int __devinit
 megaraid_init_mbox(adapter_t *adapter)
@@ -943,7 +942,7 @@ out_free_raid_dev:
 
 /**
  * megaraid_fini_mbox - undo controller initialization
- * @param adapter	: our soft state
+ * @adapter		: our soft state
  */
 static void
 megaraid_fini_mbox(adapter_t *adapter)
@@ -973,12 +972,12 @@ megaraid_fini_mbox(adapter_t *adapter)
 
 /**
  * megaraid_alloc_cmd_packets - allocate shared mailbox
- * @param adapter	: soft state of the raid controller
+ * @adapter		: soft state of the raid controller
  *
  * Allocate and align the shared mailbox. This maibox is used to issue
  * all the commands. For IO based controllers, the mailbox is also
regsitered
  * with the FW. Allocate memory for all commands as well.
- * This is our big allocator
+ * This is our big allocator.
  */
 static int
 megaraid_alloc_cmd_packets(adapter_t *adapter) @@ -1138,9 +1137,9 @@
out_free_common_mbox:
 
 /**
  * megaraid_free_cmd_packets - free memory
- * @param adapter	: soft state of the raid controller
+ * @adapter		: soft state of the raid controller
  *
- * Release memory resources allocated for commands
+ * Release memory resources allocated for commands.
  */
 static void
 megaraid_free_cmd_packets(adapter_t *adapter) @@ -1162,10 +1161,10 @@
megaraid_free_cmd_packets(adapter_t *ada
 
 /**
  * megaraid_mbox_setup_dma_pools - setup dma pool for command packets
- * @param adapter	: HBA soft state
+ * @adapter		: HBA soft state
  *
- * setup the dma pools for mailbox, passthru and extended passthru
structures,
- * and scatter-gather lists
+ * Setup the dma pools for mailbox, passthru and extended passthru 
+ structures,
+ * and scatter-gather lists.
  */
 static int
 megaraid_mbox_setup_dma_pools(adapter_t *adapter) @@ -1258,10 +1257,10
@@ fail_setup_dma_pool:
 
 /**
  * megaraid_mbox_teardown_dma_pools - teardown dma pools for command
packets
- * @param adapter	: HBA soft state
+ * @adapter		: HBA soft state
  *
- * teardown the dma pool for mailbox, passthru and extended passthru
- * structures, and scatter-gather lists
+ * Teardown the dma pool for mailbox, passthru and extended passthru
+ * structures, and scatter-gather lists.
  */
 static void
 megaraid_mbox_teardown_dma_pools(adapter_t *adapter) @@ -1306,10
+1305,11 @@ megaraid_mbox_teardown_dma_pools(adapter
 /**
  * megaraid_alloc_scb - detach and return a scb from the free list
  * @adapter	: controller's soft state
+ * @scp		: pointer to the scsi command to be executed
  *
- * return the scb from the head of the free list. NULL if there are
none
- * available
- **/
+ * Return the scb from the head of the free list. %NULL if there are 
+ none
+ * available.
+ */
 static scb_t *
 megaraid_alloc_scb(adapter_t *adapter, struct scsi_cmnd *scp)  { @@
-1343,11 +1343,11 @@ megaraid_alloc_scb(adapter_t *adapter, s
  * @adapter	: controller's soft state
  * @scb		: scb to be freed
  *
- * return the scb back to the free list of scbs. The caller must
'flush' the
+ * Return the scb back to the free list of scbs. The caller must 
+ 'flush' the
  * SCB before calling us. E.g., performing pci_unamp and/or pci_sync
etc.
  * NOTE NOTE: Make sure the scb is not on any list before calling this
  * routine.
- **/
+ */
 static inline void
 megaraid_dealloc_scb(adapter_t *adapter, scb_t *scb)  { @@ -1368,10
+1368,10 @@ megaraid_dealloc_scb(adapter_t *adapter,
 
 /**
  * megaraid_mbox_mksgl - make the scatter-gather list
- * @adapter	- controller's soft state
- * @scb		- scsi control block
+ * @adapter	: controller's soft state
+ * @scb		: scsi control block
  *
- * prepare the scatter-gather list
+ * Prepare the scatter-gather list.
  */
 static int
 megaraid_mbox_mksgl(adapter_t *adapter, scb_t *scb) @@ -1441,10
+1441,10 @@ megaraid_mbox_mksgl(adapter_t *adapter, 
 
 /**
  * mbox_post_cmd - issue a mailbox command
- * @adapter	- controller's soft state
- * @scb		- command to be issued
+ * @adapter	: controller's soft state
+ * @scb		: command to be issued
  *
- * post the command to the controller if mailbox is availble.
+ * Post the command to the controller if mailbox is available.
  */
 static int
 mbox_post_cmd(adapter_t *adapter, scb_t *scb) @@ -1524,7 +1524,7 @@
mbox_post_cmd(adapter_t *adapter, scb_t
  * Queue entry point for mailbox based controllers.
  */
 static int
-megaraid_queue_command(struct scsi_cmnd *scp, void (* done)(struct
scsi_cmnd *))
+megaraid_queue_command(struct scsi_cmnd *scp, void (*done)(struct 
+scsi_cmnd *))
 {
 	adapter_t	*adapter;
 	scb_t		*scb;
@@ -1554,15 +1554,15 @@ megaraid_queue_command(struct scsi_cmnd  }
 
 /**
- * megaraid_mbox_build_cmd - transform the mid-layer scsi command to
megaraid
- * firmware lingua
- * @adapter	- controller's soft state
- * @scp		- mid-layer scsi command pointer
- * @busy	- set if request could not be completed because of lack
of
+ * megaraid_mbox_build_cmd - transform the mid-layer scsi commands
+ * @adapter	: controller's soft state
+ * @scp		: mid-layer scsi command pointer
+ * @busy	: set if request could not be completed because of lack
of
  *		resources
  *
- * convert the command issued by mid-layer to format understood by
megaraid
- * firmware. We also complete certain command without sending them to
firmware
+ * Transform the mid-layer scsi command to megaraid firmware lingua.
+ * Convert the command issued by mid-layer to format understood by 
+ megaraid
+ * firmware. We also complete certain commands without sending them to
firmware.
  */
 static scb_t *
 megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int
*busy) @@ -1943,9 +1943,9 @@ megaraid_mbox_build_cmd(adapter_t *adapt
 /**
  * megaraid_mbox_runpendq - execute commands queued in the pending
queue
  * @adapter	: controller's soft state
- * @scb		: SCB to be queued in the pending list
+ * @scb_q	: SCB to be queued in the pending list
  *
- * scan the pending list for commands which are not yet issued and try
to
+ * Scan the pending list for commands which are not yet issued and try 
+ to
  * post to the controller. The SCB can be a null pointer, which would
indicate
  * no SCB to be queue, just try to execute the ones in the pending
list.
  *
@@ -2018,11 +2018,11 @@ megaraid_mbox_runpendq(adapter_t *adapte
 
 /**
  * megaraid_mbox_prepare_pthru - prepare a command for physical devices
- * @adapter	- pointer to controller's soft state
- * @scb		- scsi control block
- * @scp		- scsi command from the mid-layer
+ * @adapter	: pointer to controller's soft state
+ * @scb		: scsi control block
+ * @scp		: scsi command from the mid-layer
  *
- * prepare a command for the scsi physical devices
+ * Prepare a command for the scsi physical devices.
  */
 static void
 megaraid_mbox_prepare_pthru(adapter_t *adapter, scb_t *scb, @@ -2066,12
+2066,12 @@ megaraid_mbox_prepare_pthru(adapter_t *a
 
 /**
  * megaraid_mbox_prepare_epthru - prepare a command for physical
devices
- * @adapter	- pointer to controller's soft state
- * @scb		- scsi control block
- * @scp		- scsi command from the mid-layer
+ * @adapter	: pointer to controller's soft state
+ * @scb		: scsi control block
+ * @scp		: scsi command from the mid-layer
  *
- * prepare a command for the scsi physical devices. This rountine
prepares
- * commands for devices which can take extended CDBs (>10 bytes)
+ * Prepare a command for the scsi physical devices. This rountine 
+ prepares
+ * commands for devices which can take extended CDBs (>10 bytes).
  */
 static void
 megaraid_mbox_prepare_epthru(adapter_t *adapter, scb_t *scb, @@ -2115,9
+2115,9 @@ megaraid_mbox_prepare_epthru(adapter_t *
 
 /**
  * megaraid_ack_sequence - interrupt ack sequence for memory mapped
HBAs
- * @adapter	- controller's soft state
+ * @adapter	: controller's soft state
  *
- * Interrupt ackrowledgement sequence for memory mapped HBAs. Find out
the
+ * Interrupt acknowledgement sequence for memory mapped HBAs. Find out 
+ the
  * completed command and put them on the completed list for later
processing.
  *
  * Returns:	1 if the interrupt is valid, 0 otherwise
@@ -2230,9 +2230,8 @@ megaraid_ack_sequence(adapter_t *adapter
 
 /**
  * megaraid_isr - isr for memory based mailbox based controllers
- * @irq		- irq
- * @devp	- pointer to our soft state
- * @regs	- unused
+ * @irq		: irq
+ * @devp	: pointer to our soft state
  *
  * Interrupt service routine for memory-mapped mailbox controllers.
  */
@@ -2677,7 +2676,7 @@ megaraid_abort_handler(struct scsi_cmnd
  * the FW is still live, in which case the outstanding commands counter
mut go
  * down to 0. If that happens, also issue the reservation reset command
to
  * relinquish (possible) reservations on the logical drives connected
to this
- * host
+ * host.
  **/
 static int
 megaraid_reset_handler(struct scsi_cmnd *scp) @@ -2829,11 +2828,11 @@
megaraid_reset_handler(struct scsi_cmnd 
 
 /**
  * mbox_post_sync_cmd() - blocking command to the mailbox based
controllers
- * @adapter	- controller's soft state
- * @raw_mbox	- the mailbox
+ * @adapter	: controller's soft state
+ * @raw_mbox	: the mailbox
  *
  * Issue a scb in synchronous and non-interrupt mode for mailbox based
- * controllers
+ * controllers.
  */
 static int
 mbox_post_sync_cmd(adapter_t *adapter, uint8_t raw_mbox[]) @@ -2961,12
+2960,12 @@ blocked_mailbox:
 
 /**
  * mbox_post_sync_cmd_fast - blocking command to the mailbox based
controllers
- * @adapter	- controller's soft state
- * @raw_mbox	- the mailbox
+ * @adapter	: controller's soft state
+ * @raw_mbox	: the mailbox
  *
  * Issue a scb in synchronous and non-interrupt mode for mailbox based
  * controllers. This is a faster version of the synchronous command and
- * therefore can be called in interrupt-context as well
+ * therefore can be called in interrupt-context as well.
  */
 static int
 mbox_post_sync_cmd_fast(adapter_t *adapter, uint8_t raw_mbox[]) @@
-3014,10 +3013,10 @@ mbox_post_sync_cmd_fast(adapter_t *adapt
 
 /**
  * megaraid_busywait_mbox() - Wait until the controller's mailbox is
available
- * @raid_dev	- RAID device (HBA) soft state
+ * @raid_dev	: RAID device (HBA) soft state
  *
- * wait until the controller's mailbox is available to accept more
commands.
- * wait for at most 1 second
+ * Wait until the controller's mailbox is available to accept more
commands.
+ * Wait for at most 1 second.
  */
 static int
 megaraid_busywait_mbox(mraid_device_t *raid_dev) @@ -3038,9 +3037,9 @@
megaraid_busywait_mbox(mraid_device_t *r
 
 /**
  * megaraid_mbox_product_info - some static information about the
controller
- * @adapter	- our soft state
+ * @adapter	: our soft state
  *
- * issue commands to the controller to grab some parameters required by
our
+ * Issue commands to the controller to grab some parameters required by

+ our
  * caller.
  */
 static int
@@ -3163,10 +3162,10 @@ megaraid_mbox_product_info(adapter_t *ad
 
 /**
  * megaraid_mbox_extended_cdb - check for support for extended CDBs
- * @adapter	- soft state for the controller
+ * @adapter	: soft state for the controller
  *
- * this routine check whether the controller in question supports
extended
- * ( > 10 bytes ) CDBs
+ * This routine check whether the controller in question supports 
+ extended
+ * ( > 10 bytes ) CDBs.
  */
 static int
 megaraid_mbox_extended_cdb(adapter_t *adapter) @@ -3199,8 +3198,8 @@
megaraid_mbox_extended_cdb(adapter_t *ad
 
 /**
  * megaraid_mbox_support_ha - Do we support clustering
- * @adapter	- soft state for the controller
- * @init_id	- ID of the initiator
+ * @adapter	: soft state for the controller
+ * @init_id	: ID of the initiator
  *
  * Determine if the firmware supports clustering and the ID of the
initiator.
  */
@@ -3242,9 +3241,9 @@ megaraid_mbox_support_ha(adapter_t *adap
 
 /**
  * megaraid_mbox_support_random_del - Do we support random deletion
- * @adapter	- soft state for the controller
+ * @adapter	: soft state for the controller
  *
- * Determine if the firmware supports random deletion
+ * Determine if the firmware supports random deletion.
  * Return:	1 is operation supported, 0 otherwise
  */
 static int
@@ -3277,10 +3276,10 @@ megaraid_mbox_support_random_del(adapter
 
 /**
  * megaraid_mbox_get_max_sg - maximum sg elements supported by the
firmware
- * @adapter	- soft state for the controller
+ * @adapter	: soft state for the controller
  *
  * Find out the maximum number of scatter-gather elements supported by
the
- * firmware
+ * firmware.
  */
 static int
 megaraid_mbox_get_max_sg(adapter_t *adapter) @@ -3317,10 +3316,10 @@
megaraid_mbox_get_max_sg(adapter_t *adap
 
 /**
  * megaraid_mbox_enum_raid_scsi - enumerate the RAID and SCSI channels
- * @adapter	- soft state for the controller
+ * @adapter	: soft state for the controller
  *
- * Enumerate the RAID and SCSI channels for ROMB platoforms so that
channels
- * can be exported as regular SCSI channels
+ * Enumerate the RAID and SCSI channels for ROMB platforms so that 
+ channels
+ * can be exported as regular SCSI channels.
  */
 static void
 megaraid_mbox_enum_raid_scsi(adapter_t *adapter) @@ -3354,9 +3353,9 @@
megaraid_mbox_enum_raid_scsi(adapter_t *
 
 /**
  * megaraid_mbox_flush_cache - flush adapter and disks cache
- * @param adapter	: soft state for the controller
+ * @adapter		: soft state for the controller
  *
- * Flush adapter cache followed by disks cache
+ * Flush adapter cache followed by disks cache.
  */
 static void
 megaraid_mbox_flush_cache(adapter_t *adapter) @@ -3387,9 +3386,9 @@
megaraid_mbox_flush_cache(adapter_t *ada
 
 /**
  * megaraid_mbox_fire_sync_cmd - fire the sync cmd
- * @param adapter	: soft state for the controller
+ * @adapter		: soft state for the controller
  *
- * Clears the pending cmds in FW and reinits its RAID structs
+ * Clears the pending cmds in FW and reinits its RAID structs.
  */
 static int
 megaraid_mbox_fire_sync_cmd(adapter_t *adapter) @@ -3465,12 +3464,12 @@
blocked_mailbox:
 
 /**
  * megaraid_mbox_display_scb - display SCB information, mostly debug
purposes
- * @param adapter	: controllers' soft state
- * @param scb		: SCB to be displayed
- * @param level	: debug level for console print
+ * @adapter		: controller's soft state
+ * @scb			: SCB to be displayed
+ * @level		: debug level for console print
  *
  * Diplay information about the given SCB iff the current debug level
is
- * verbose
+ * verbose.
  */
 static void
 megaraid_mbox_display_scb(adapter_t *adapter, scb_t *scb) @@ -3518,7
+3517,7 @@ megaraid_mbox_display_scb(adapter_t *ada
  * scsi addresses and megaraid scsi and logical drive addresses. We
export
  * scsi devices on their actual addresses, whereas the logical drives
are
  * exported on a virtual scsi channel.
- **/
+ */
 static void
 megaraid_mbox_setup_device_map(adapter_t *adapter)  { @@ -3556,7
+3555,7 @@ megaraid_mbox_setup_device_map(adapter_t
 
 /**
  * megaraid_cmm_register - register with the mangement module
- * @param adapter	: HBA soft state
+ * @adapter		: HBA soft state
  *
  * Register with the management module, which allows applications to
issue
  * ioctl calls to the drivers. This interface is used by the management
module @@ -3646,11 +3645,11 @@ megaraid_cmm_register(adapter_t *adapter
 
 /**
  * megaraid_cmm_unregister - un-register with the mangement module
- * @param adapter	: HBA soft state
+ * @adapter		: HBA soft state
  *
  * Un-register with the management module.
  * FIXME: mgmt module must return failure for unregister if it has
pending
- * commands in LLD
+ * commands in LLD.
  */
 static int
 megaraid_cmm_unregister(adapter_t *adapter) @@ -3663,9 +3662,9 @@
megaraid_cmm_unregister(adapter_t *adapt
 
 /**
  * megaraid_mbox_mm_handler - interface for CMM to issue commands to
LLD
- * @param drvr_data	: LLD specific data
- * @param kioc		: CMM interface packet
- * @param action	: command action
+ * @drvr_data		: LLD specific data
+ * @kioc		: CMM interface packet
+ * @action		: command action
  *
  * This routine is invoked whenever the Common Mangement Module (CMM)
has a
  * command for us. The 'action' parameter specifies if this is a new
command @@ -3718,8 +3717,8 @@ megaraid_mbox_mm_handler(unsigned long d
 
 /**
  * megaraid_mbox_mm_command - issues commands routed through CMM
- * @param adapter	: HBA soft state
- * @param kioc		: management command packet
+ * @adapter		: HBA soft state
+ * @kioc		: management command packet
  *
  * Issues commands, which are routed through the management module.
  */
@@ -3888,8 +3887,8 @@ megaraid_mbox_mm_done(adapter_t *adapter
 
 /**
  * gather_hbainfo - HBA characteristics for the applications
- * @param adapter	: HBA soft state
- * @param hinfo		: pointer to the caller's host info
strucuture
+ * @adapter		: HBA soft state
+ * @hinfo		: pointer to the caller's host info strucuture
  */
 static int
 gather_hbainfo(adapter_t *adapter, mraid_hba_info_t *hinfo) @@ -3923,16
+3922,15 @@ gather_hbainfo(adapter_t *adapter, mraid
 
 /**
  * megaraid_sysfs_alloc_resources - allocate sysfs related resources
+ * @adapter	: controller's soft state
  *
  * Allocate packets required to issue FW calls whenever the sysfs
attributes
  * are read. These attributes would require up-to-date information from
the
  * FW. Also set up resources for mutual exclusion to share these
resources and
  * the wait queue.
  *
- * @param adapter : controller's soft state
- *
- * @return 0 on success
- * @return -ERROR_CODE on failure
+ * Return 0 on success.
+ * Return -ERROR_CODE on failure.
  */
 static int
 megaraid_sysfs_alloc_resources(adapter_t *adapter) @@ -3969,10 +3967,9
@@ megaraid_sysfs_alloc_resources(adapter_t
 
 /**
  * megaraid_sysfs_free_resources - free sysfs related resources
+ * @adapter	: controller's soft state
  *
  * Free packets allocated for sysfs FW commands
- *
- * @param adapter : controller's soft state
  */
 static void
 megaraid_sysfs_free_resources(adapter_t *adapter) @@ -3991,10 +3988,9
@@ megaraid_sysfs_free_resources(adapter_t 
 
 /**
  * megaraid_sysfs_get_ldmap_done - callback for get ldmap
+ * @uioc	: completed packet
  *
  * Callback routine called in the ISR/tasklet context for get ldmap
call
- *
- * @param uioc : completed packet
  */
 static void
 megaraid_sysfs_get_ldmap_done(uioc_t *uioc) @@ -4010,12 +4006,11 @@
megaraid_sysfs_get_ldmap_done(uioc_t *ui
 
 /**
  * megaraid_sysfs_get_ldmap_timeout - timeout handling for get ldmap
+ * @data	: timed out packet
  *
  * Timeout routine to recover and return to application, in case the
adapter
- * has stopped responding. A timeout of 60 seconds for this command
seem like
- * a good value
- *
- * @param uioc : timed out packet
+ * has stopped responding. A timeout of 60 seconds for this command 
+ seems like
+ * a good value.
  */
 static void
 megaraid_sysfs_get_ldmap_timeout(unsigned long data) @@ -4032,6 +4027,7
@@ megaraid_sysfs_get_ldmap_timeout(unsigne
 
 /**
  * megaraid_sysfs_get_ldmap - get update logical drive map
+ * @adapter	: controller's soft state
  *
  * This routine will be called whenever user reads the logical drive
  * attributes, go get the current logical drive mapping table from the
@@ -4043,10 +4039,8 @@ megaraid_sysfs_get_ldmap_timeout(unsigne
  * standalone libary. For now, this should suffice since there is no
other
  * user of this interface.
  *
- * @param adapter : controller's soft state
- *
- * @return 0 on success
- * @return -1 on failure
+ * Return 0 on success.
+ * Return -1 on failure.
  */
 static int
 megaraid_sysfs_get_ldmap(adapter_t *adapter) @@ -4148,13 +4142,12 @@
megaraid_sysfs_get_ldmap(adapter_t *adap
 
 /**
  * megaraid_sysfs_show_app_hndl - display application handle for this
adapter
+ * @cdev	: class device object representation for the host
+ * @buf		: buffer to send data to
  *
  * Display the handle used by the applications while executing
management
  * tasks on the adapter. We invoke a management module API to get the
adapter
  * handle, since we do not interface with applications directly.
- *
- * @param cdev	: class device object representation for the host
- * @param buf	: buffer to send data to
  */
 static ssize_t
 megaraid_sysfs_show_app_hndl(struct class_device *cdev, char *buf) @@
-4171,16 +4164,18 @@ megaraid_sysfs_show_app_hndl(struct clas
 
 /**
  * megaraid_sysfs_show_ldnum - display the logical drive number for
this device
+ * @dev		: device object representation for the scsi
device
+ * @attr	: device attribute to show
+ * @buf		: buffer to send data to
  *
  * Display the logical drive number for the device in question, if it a
valid
- * logical drive. For physical devices, "-1" is returned
- * The logical drive number is displayed in following format
+ * logical drive. For physical devices, "-1" is returned.
+ *
+ * The logical drive number is displayed in following format:
  *
  * <SCSI ID> <LD NUM> <LD STICKY ID> <APP ADAPTER HANDLE>
- *   <int>     <int>       <int>            <int>
  *
- * @param dev	: device object representation for the scsi device
- * @param buf	: buffer to send data to
+ *   <int>     <int>       <int>            <int>
  */
 static ssize_t
 megaraid_sysfs_show_ldnum(struct device *dev, struct device_attribute
*attr, char *buf)
--- linux-2620-rc3g4.orig/drivers/scsi/megaraid/megaraid_mm.c
+++ linux-2620-rc3g4/drivers/scsi/megaraid/megaraid_mm.c
@@ -78,10 +78,10 @@ static struct file_operations lsi_fops =
 
 /**
  * mraid_mm_open - open routine for char node interface
- * @inod	: unused
+ * @inode	: unused
  * @filep	: unused
  *
- * allow ioctl operations by apps only if they superuser privilege
+ * Allow ioctl operations by apps only if they have superuser
privilege.
  */
 static int
 mraid_mm_open(struct inode *inode, struct file *filep) @@ -214,7 +214,9
@@ mraid_mm_ioctl(struct inode *inode, stru
 /**
  * mraid_mm_get_adapter - Returns corresponding adapters for the mimd
packet
  * @umimd	: User space mimd_t ioctl packet
- * @adapter	: pointer to the adapter (OUT)
+ * @rval	: returned success/error status
+ *
+ * The function return value is a pointer to the located @adapter.
  */
 static mraid_mmadp_t *
 mraid_mm_get_adapter(mimd_t __user *umimd, int *rval) @@ -252,11
+254,11 @@ mraid_mm_get_adapter(mimd_t __user *umim
 	return adapter;
 }
 
-/*
- * handle_drvrcmd - This routine checks if the opcode is a driver
- * 			  cmd and if it is, handles it.
+/**
+ * handle_drvrcmd - Checks if the opcode is a driver cmd and if it is,
handles it.
  * @arg		: packet sent by the user app
  * @old_ioctl	: mimd if 1; uioc otherwise
+ * @rval	: pointer for command's returned value (not function
status)
  */
 static int
 handle_drvrcmd(void __user *arg, uint8_t old_ioctl, int *rval) @@
-322,8 +324,8 @@ old_packet:
 
 /**
  * mimd_to_kioc	- Converter from old to new ioctl format
- *
  * @umimd	: user space old MIMD IOCTL
+ * @adp		: adapter softstate
  * @kioc	: kernel space new format IOCTL
  *
  * Routine to convert MIMD interface IOCTL to new interface IOCTL
packet. The @@ -474,7 +476,6 @@ mimd_to_kioc(mimd_t __user *umimd, mraid
 
 /**
  * mraid_mm_attch_buf - Attach a free dma buffer for required size
- *
  * @adp		: Adapter softstate
  * @kioc	: kioc that the buffer needs to be attached to
  * @xferlen	: required length for buffer
@@ -607,7 +608,6 @@ mraid_mm_alloc_kioc(mraid_mmadp_t *adp)
 
 /**
  * mraid_mm_dealloc_kioc - Return kioc to free pool
- *
  * @adp		: Adapter softstate
  * @kioc	: uioc_t node to be returned to free pool
  */
@@ -652,7 +652,6 @@ mraid_mm_dealloc_kioc(mraid_mmadp_t *adp
 
 /**
  * lld_ioctl - Routine to issue ioctl to low level drvr
- *
  * @adp		: The adapter handle
  * @kioc	: The ioctl packet with kernel addresses
  */
@@ -705,7 +704,6 @@ lld_ioctl(mraid_mmadp_t *adp, uioc_t *ki
 
 /**
  * ioctl_done - callback from the low level driver
- *
  * @kioc	: completed ioctl packet
  */
 static void
@@ -756,9 +754,8 @@ ioctl_done(uioc_t *kioc)  }
 
 
-/*
- * lld_timedout	: callback from the expired timer
- *
+/**
+ * lld_timedout	- callback from the expired timer
  * @ptr		: ioctl packet that timed out
  */
 static void
@@ -776,8 +773,7 @@ lld_timedout(unsigned long ptr)
 
 
 /**
- * kioc_to_mimd	: Converter from new back to old format
- *
+ * kioc_to_mimd	- Converter from new back to old format
  * @kioc	: Kernel space IOCTL packet (successfully issued)
  * @mimd	: User space MIMD packet
  */
@@ -855,7 +851,6 @@ kioc_to_mimd(uioc_t *kioc, mimd_t __user
 
 /**
  * hinfo_to_cinfo - Convert new format hba info into old format
- *
  * @hinfo	: New format, more comprehensive adapter info
  * @cinfo	: Old format adapter info to support mimd_t apps
  */
@@ -878,10 +873,9 @@ hinfo_to_cinfo(mraid_hba_info_t *hinfo,  }
 
 
-/*
- * mraid_mm_register_adp - Registration routine for low level drvrs
- *
- * @adp	: Adapter objejct
+/**
+ * mraid_mm_register_adp - Registration routine for low level drivers
+ * @lld_adp	: Adapter objejct
  */
 int
 mraid_mm_register_adp(mraid_mmadp_t *lld_adp) @@ -1007,15 +1001,14 @@
memalloc_error:
 
 /**
  * mraid_mm_adapter_app_handle - return the application handle for this
adapter
+ * @unique_id	: adapter unique identifier
  *
- * For the given driver data, locate the adadpter in our global list
and
+ * For the given driver data, locate the adapter in our global list and
  * return the corresponding handle, which is also used by applications
to
  * uniquely identify an adapter.
  *
- * @param unique_id : adapter unique identifier
- *
- * @return adapter handle if found in the list
- * @return 0 if adapter could not be located, should never happen
though
+ * Return adapter handle if found in the list.
+ * Return 0 if adapter could not be located, should never happen
though.
  */
 uint32_t
 mraid_mm_adapter_app_handle(uint32_t unique_id) @@ -1040,7 +1033,6 @@
mraid_mm_adapter_app_handle(uint32_t uni
 
 /**
  * mraid_mm_setup_dma_pools - Set up dma buffer pools per adapter
- *
  * @adp	: Adapter softstate
  *
  * We maintain a pool of dma buffers per each adapter. Each pool has
one @@ -1093,11 +1085,11 @@ dma_pool_setup_error:
 }
 
 
-/*
+/**
  * mraid_mm_unregister_adp - Unregister routine for low level drivers
- *				  Assume no outstanding ioctls to llds.
- *
  * @unique_id	: UID of the adpater
+ *
+ * Assumes no outstanding ioctls to llds.
  */
 int
 mraid_mm_unregister_adp(uint32_t unique_id) @@ -1131,7 +1123,6 @@
mraid_mm_unregister_adp(uint32_t unique_
 
 /**
  * mraid_mm_free_adp_resources - Free adapter softstate
- *
  * @adp	: Adapter softstate
  */
 static void
@@ -1162,7 +1153,6 @@ mraid_mm_free_adp_resources(mraid_mmadp_
 
 /**
  * mraid_mm_teardown_dma_pools - Free all per adapter dma buffers
- *
  * @adp	: Adapter softstate
  */
 static void
@@ -1190,7 +1180,7 @@ mraid_mm_teardown_dma_pools(mraid_mmadp_
 }
 
 /**
- * mraid_mm_init	: Module entry point
+ * mraid_mm_init	- Module entry point
  */
 static int __init
 mraid_mm_init(void)
@@ -1214,10 +1204,13 @@ mraid_mm_init(void)  }
 
 
+#ifdef CONFIG_COMPAT
 /**
- * mraid_mm_compat_ioctl	: 32bit to 64bit ioctl conversion
routine
+ * mraid_mm_compat_ioctl	- 32bit to 64bit ioctl conversion
routine
+ * @filep	: file operations pointer (ignored)
+ * @cmd		: ioctl command
+ * @arg		: user ioctl packet
  */
-#ifdef CONFIG_COMPAT
 static long
 mraid_mm_compat_ioctl(struct file *filep, unsigned int cmd,
 		      unsigned long arg)
@@ -1231,7 +1224,7 @@ mraid_mm_compat_ioctl(struct file *filep  #endif
 
 /**
- * mraid_mm_exit	: Module exit point
+ * mraid_mm_exit	- Module exit point
  */
 static void __exit
 mraid_mm_exit(void)
--- linux-2620-rc3g4.orig/drivers/scsi/megaraid/megaraid_sas.h
+++ linux-2620-rc3g4/drivers/scsi/megaraid/megaraid_sas.h
@@ -15,7 +15,7 @@
 #ifndef LSI_MEGARAID_SAS_H
 #define LSI_MEGARAID_SAS_H
 
-/**
+/*
  * MegaRAID SAS Driver meta data
  */
 #define MEGASAS_VERSION				"00.00.03.05"
@@ -40,7 +40,7 @@
  * "message frames"
  */
 
-/**
+/*
  * FW posts its state in upper 4 bits of outbound_msg_0 register
  */
 #define MFI_STATE_MASK				0xF0000000
@@ -58,7 +58,7 @@
 
 #define MEGAMFI_FRAME_SIZE			64
 
-/**
+/*
  * During FW init, clear pending cmds & reset state using inbound_msg_0
  *
  * ABORT	: Abort all pending cmds
@@ -78,7 +78,7 @@
 						MFI_INIT_MFIMODE| \
 						MFI_INIT_ABORT
 
-/**
+/*
  * MFI frame flags
  */
 #define MFI_FRAME_POST_IN_REPLY_QUEUE		0x0000
@@ -92,12 +92,12 @@
 #define MFI_FRAME_DIR_READ			0x0010
 #define MFI_FRAME_DIR_BOTH			0x0018
 
-/**
+/*
  * Definition for cmd_status
  */
 #define MFI_CMD_STATUS_POLL_MODE		0xFF
 
-/**
+/*
  * MFI command opcodes
  */
 #define MFI_CMD_INIT				0x00
@@ -128,7 +128,7 @@
 #define MR_DCMD_CLUSTER_RESET_ALL		0x08010100
 #define MR_DCMD_CLUSTER_RESET_LD		0x08010200
 
-/**
+/*
  * MFI command completion codes
  */
 enum MFI_STAT {


---
