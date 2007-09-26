From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: queued patches for SCSI for 2.6.24
Date: Tue, 25 Sep 2007 20:00:02 -0500
Message-ID: <1190768402.8707.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56749 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751241AbXIZBAF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 21:00:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Andrew asked that I provide a status report of pending updates.  The
list is attached below.  It's pretty much driver updates and minor bug
fixes.  The main functionality changes are Kay's sysfs updates and the
shift of the ULD attachement towards the block prep function.

James

---


Adrian Bunk (2):
      make scsi_decode_sense_buffer and scsi_decode_sense_extras static
      scsi_error.c should #include "scsi_transport_api.h"

Alan Cox (3):
      dtc: Fix typo
      eata_pio: Clean up proc handling, bracketing and use cpu_relax()
      dtc: clean up indent damage and add printk levels

Andrew Morton (3):
      ips: warning fix
      aacraid: rename check_reset
      bsg: declare structures for the non BSG case

Andrew Vasquez (15):
      qla2xxx: Update version number to 8.02.00-k4.
      qla2xxx: Limit iIDMA speed adjustments.
      qla2xxx: Rework MSI-X handlers.
      qla2xxx: Clear options-flags while staging firmware-execution.
      qla2xxx: Sparse cleanups in qla_mid.c
      qla2xxx: Cleanup several 'sparse' warnings.
      qla2xxx: Use shost_priv().
      qla2xxx: Remove unused member (list) from srb_t structure.
      qla2xxx: Use the correct pointer-address during NVRAM writes.
      qla2xxx: Set correct attribute count during FDMI RPA.
      qla2xxx: Query additional RISC registers during ISP25XX firmware dump.
      qla2xxx: Correct staging of RISC while attempting to pause.
      qla2xxx: Query additional RISC information during a pause.
      qla2xxx: Add flash burst-read/write support.
      qla2xxx: Collapse and simplify ISP2XXX firmware dump routines.

Bartlomiej Zolnierkiewicz (1):
      MAINTAINERS: mark ide-scsi as Orphan

Bernhard Walle (1):
      ips: Update version information

Boaz Harrosh (2):
      ide-scsi.: convert to data accessors and !use_sg cleanup
      microtek: use data accessors and !use_sg cleanup

Christof Schmitt (5):
      zfcp: Enable debug feature before setting adapter online
      scsi_transport_fc: Introduce disable_target_scan flag
      zfcp: Remove braces for only one statement
      zfcp: Remove unnecessary assignment
      zfcp: correct indentation for nested if-else

David Miller (1):
      esp: fix instance numbering.

David Woodhouse (1):
      Fix ibmvscsi client for multiplatform iSeries+pSeries kernel

Eric Moore (10):
      MAINTAINERS : mpt fusion mailing list change
      mpt fusion: bump version to 3.04.06
      mpt fusion: Kconfig cleanup
      mpt fusion: removing Dell copyright
      mpt fusion: removing references to hd->ioc
      mpt fusion: rename vdev to vdevice
      mpt fusion: adding/removing white space
      mpt fusion: standardize printks and debug info
      mpt fusion: Add support for ATTO 4LD: Rebranded LSI 53C1030
      Addition to pci_ids.h for ATTO Technology, Inc.

FUJITA Tomonori (17):
      srp_transport: convert to use supported_mode attribute
      fc_transport: add target driver support
      add supported_mode and active_mode attributes to the host
      tgt: fix can_queue bug
      fc4: convert to use the data buffer accessors
      sg: increase sglist_len of the sg_scatter_hold structure
      ps3rom: convert to use the data buffer accessors
      scsi_transport_srp: remove tgt dependencies
      tgt: convert ibmvstgt to use transport tsk_mgmt_response callback
      tgt: move tsk_mgmt_response callback to transport class
      tgt: convert libsrp and ibmvstgt to use srp_transport
      srp_transport: add target driver support
      tgt: add I_T nexus support
      transport_srp: add rport roles attribute
      ib_srp: convert to use the srp transport class
      ibmvscsi: convert to use the srp transport class
      add srp transport class

Gabriel C (1):
      NCR5380: fix NCR53C400_PSEUDO_DMA is not defined

Gilbert Wu (1):
      aic94xx: Add new PCI ID for ASC58300

Heiko Carstens (3):
      zfcp: avoid if (whatever) ; constructs.
      zfcp: allocate gid_pn_data objects from gid_pn_cache.
      zfcp: fix memory leak.

HighPoint Linux Team (1):
      hptiop: adding new firmware interface and more PCI device IDs

James Bottomley (3):
      sg: use idr to replace static arrays
      move ULD attachment into the prep function
      arcmsr: fix compile problems

Jan Engelhardt (1):
      mpt fusion: Use menuconfig objects

Jeff Garzik (2):
      arcmsr: irq handler fixes, cleanups, micro-opts
      arcmsr: Fix hardware wait loops

Jesper Juhl (3):
      mpt fusion: fix two potential mem leaks
      NCR_D700, lpfc: Clean up duplicate includes
      lpfc: fix potential overflow of hbqs array

Joe Carnuccio (1):
      qla2xxx: Allow region-based flash-part accesses.

Kay Sievers (1):
      switch sdev sysfs attributes to default attributes

Mariusz Kozlowski (3):
      mpt fusion: remove redundant memset
      mpt fusion: mostly kmalloc + memset conversion to kzalloc
      kmalloc + memset conversion to kzalloc

Masatake YAMATO (1):
      Fix signness of parameters in scsi module

Matthew Wilcox (49):
      ips: Close narrow race in release
      aic94xx: Free scsi host on error
      simscsi: Free scsi host on error
      qlogicfas: Close narrow race in release
      aha152x: Close narrow race in release
      ncr53c8xx: Call scsi_host_put in release
      ide-scsi: Close narrow race in release
      ibmmca: Stop leaking scsi_hosts on exit
      scsi_scan: Cope with kthread_run failing
      Improve error message when offlining a device
      advansys: Use DRV_NAME
      advansys: Comment/indentation/macro cleanup
      advansys: Remove some custom wrappers
      advansys: Remove a check for an impossible condition
      advansys: Support 16-byte commands properly
      advansys: Enable interrupts earlier in queuecommand
      advansys: Remove `active' queue and all remaining internal queueing code
      advansys: Remove `done' queue
      advansys: Remove a check for an impossible condition
      advansys: Remove `waiting' queue
      advansys: Shrink advansys_board_found a little more
      advansys: Reformat microcode
      advansys: Create AdvLoadMicrocode
      advansys: Create AdvBuildCarrierFreelist
      advansys: Fix VLB driver name
      advansys: Move documentation to Documentation/scsi
      advansys: use memcpy instead of open-coded loop
      advansys: Remove pci_slot_info
      advansys: Remove library-style callback routines
      advansys: Move struct device out of the cfg structures
      advansys: Stop using n_io_port in Scsi_Host structure
      advansys: ioremap no longer needs page-aligned addresses
      advansys: delete AscGetChipBusType
      advansys: misc reformatting
      advansys: remove INQUIRY sniffing
      Add QUANTUM XP34301 to the blacklist
      advansys: remove AscCompareString()
      advansys: More PCI cleanups
      advansys: Update resource management
      advansys: Convert to ISA driver model
      advansys: Convert to EISA driver model
      advansys: Convert to PCI driver model
      advansys: Move to scsi hotplug initialisation model
      advansys: Make advansys_board_found a little more readable
      advansys: Stop checking the scsi_cmnd belongs to our Scsi_Host
      advansys: Improve interrupt handler
      advansys: Clean up proc_info implementation
      advansys: undate version, copyright, etc
      Fix async scanning double-add problems

Matthias Kaehlcke (1):
      osst: Use mutex instead of semaphore

Michael Reed (1):
      stale residual returned on write following BUSY retry

Mike Christie (1):
      fix write buffer length in scsi_req_map_sg()

Nick Cheng (1):
      arcmsr: 1.20.00.15: add SATA RAID plus other fixes

Prakash, Sathya (5):
      mpt fusion: Change company name from LSI Logic to LSI
      mpt fusion: Link speed change display support
      mpt fusion: Creation of mptsas.h header file
      mpt fusion: Change call back indices to u8 from int
      mpt fusion: Usage of high priority request FIFO to send task management commands

Ravi Anand (1):
      qla2xxx: Correct infinite-login-retry issue.

Salyzyn, Mark (1):
      aacraid: Add documentation for new Adaptec, SMC and SUN cards

Seokmann Ju (2):
      qla2xxx: Retrieve max-NPIV support capabilities from FW.
      qla2xxx: Add PCI error recovery support.

Swen Schillig (2):
      zfcp: whitespace cleanup
      zfcp: cleanup, separation of ERP, non ERP-version for exchange_ functions


