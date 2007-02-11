From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] SCSI updates for 2.6.20
Date: Sat, 10 Feb 2007 21:57:32 -0600
Message-ID: <1171166252.3373.58.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:36520 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752016AbXBKD5i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Feb 2007 22:57:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is the accumulated SCSI tree for 2.6.20.  It is available at

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adrian Bunk (1):
       aic79xx: make ahd_match_scb() static

Ahmed S. Darwish (1):
       DAC960: kmalloc->kzalloc/Casting cleanups

Alexis Bruemmer (1):
       aic94xx: fix typos and update verison number

Andrew Morton (1):
       scsi_kmap_atomic_sg(): check that local irqs are disabled

Andrew Vasquez (12):
       qla2xxx: Update version number to 8.01.07-k5.
       qla2xxx: Fixup printk() with proper new-line character.
       qla2xxx: Allow NVRAM updates to immediately go into effect.
       qla2xxx: Enable queue-full throttling when UNDERRUN detected.
       qla2xxx: Fail initialization when inconsistent NVRAM detected.
       qla2xxx: Check loop-state before reading host statistics.
       qla2xxx: Refactor set-HBA-model/description code.
       qla2xxx: Set correct cabling state during initialization.
       qla2xxx: Export OptionROM boot-codes version information.
       qla2xxx: Handle IRQ-0 assignments by the system.
       qla2xxx: Add MSI-X support.
       qla2xxx: Correct sector-erase issues while writing flash.

Brian King (5):
       scsi_error: Fix lost EH commands
       ipr: Driver version 2.3.1
       ipr: PCI error recovery fix
       ipr: Tolerate not finding PCI-X registers
       ipr: Remove usage of pci driver data

Christoph Hellwig (1):
       kill scsi_rety_command

Darrick J. Wong (32):
       aic94xx: Add default bus reset handler
       aic94xx: Remove TMF result code munging
       libsas: Add an LU reset mechanism to the error handler
       libsas: Don't BUG when connecting two expanders via wide port
       libsas: Enable automatic spin-up of SAS disks
       aic94xx: Register eh_device_reset_handler
       libsas: Handle SCSI commands that complete with failure codes
       scsi_error.c: Export some scsi_eh_* functions
       libsas: Check return values of sysfs_create_link
       libsas: Clean up discovery failure handler code
       libsas: Fix incorrect sas_port deformation in sas_form_port
       libsas: Start I_T recovery if ABORT TASK fails
       libsas: Add SAS_HA state flags to avoid queueing events while unloading
       libsas: phy port lock needs irq spinlocks
       aic94xx: Scan SAS devices asynchronously
       libsas: sysfs phy control attributes should not be S_IWUGO
       aic94xx: Lock DDB read/write accesses
       aic94xx: Fix DDB and SCB initialization
       aic94xx: Match request_firmware with release_firmware
       aic94xx: Remove workqueue code from REQ_TASK_ABORT/REQ_DEVICE_RESET code
       libsas: Delay issuing ABORT TASK TMF until the error handler
       libsas: Enable the EH strategy handler to reset a phy after a command
       libsas: Remove SAS_TASK_INITIATOR_ABORTED flag
       aic94xx: Don't eat TMF_QUERY_TASK results
       libsas: Use SCAN_WILD_CARD instead of ~0
       aic94xx: Set lldd_max_execute_num in sas_ha
       libsas: Destroy the task collector thread after releasing ports
       libsas: Reset timer on taskless scsi_cmnds in sas_scsi_timed_out
       libsas: Add a sysfs knob to enable/disable a phy
       libsas: Don't give scsi_cmnds to the EH if they never made it to the SAS LLDD or have already returned
       libsas: Clean up rphys/port dev list after a discovery error on an expander
       libsas: Clean up rphys/port dev list after a discovery error.

Douglas Gilbert (2):
       scsi_debug: error processing
       mptctl for mptsas

Eric Moore (11):
       fusion - bump version - 3.04.04
       fusion - error handling bug fix's
       fusion - report wide port sas address's for hba phys
       fusion - serialize target resets in mptsas.c
       fusion - inactive raid support, and raid event bug fix's
       fusion - iocstatus, loginfo, and event debug updates
       fusion - added mptspi debug
       fusion - move SPI API over to mptspi.c
       fusion - Greater than 255 target and lun support
       spi transport class: export spi_dv_pending
       fusion: mpi header update - version 1.05.14

FUJITA Tomonori (1):
       libsas: fix task attribute

Greg Kroah-Hartman (1):
       ipr: remove duplicate device id

Hannes Reinecke (1):
       aic79xx: use dma_get_required_mask()

James Bottomley (1):
       NCR_D700: needs burst length setting to 8

Jiri Kosina (1):
       Buslogic: local_irq_disable() is redundant after local_irq_save()

Kai Makisara (1):
       st: fix Tape dies if wrong block size used, bug 7919

Ken Witherow (1):
       advansys: clean up warnings

Kurt Garloff (1):
       scsi_scan message cosmetic error

Lalit Chandivade (1):
       qla2xxx: Perform implicit LOGO during fabric logout request.

Luben Tuikov (1):
       Fix sense key MEDIUM ERROR processing and retry

Mariusz Kozlowski (2):
       aic79xx: fix bracket mismatch in unused macro
       53c7xx: brackets fix in uncompiled code

Mark Haverkamp (5):
       NCR_D700: fix compile error
       aacraid: expanded expose physical device code (new)
       aacraid: rework packet support code
       aacraid: Begin adding support for new adapter type
       aacraid: rework communication support code

Michal Piotrowski (1):
       nsp_cs: remove old scsi code

Randy Dunlap (2):
       megaraid: more kernel-doc fixes
       megaraid: fix kernel-doc

Richard Knutsson (1):
       BusLogic: Replace 'boolean' by 'bool'

Seokmann Ju (2):
       qla2xxx: Remove unnecessary spinlock primitive - mbx_reg_lock.
       qla2xxx: correct locking while call starget_for_each_device()

Sumant Patro (1):
       megaraid_{mm,mbox}: init fix for kdump

Swen Schillig (3):
       zfcp: removed wrong comment
       zfcp: use of uninitialized variable
       zfcp: Invalid locking order

Thomas Bogendoerfer (2):
       SNI RM 53c710 driver
       53c700: Allow setting burst length

Wu, Gilbert (1):
       aic94xx: update for v28 firmware

And the diffstat

 Documentation/scsi/ChangeLog.megaraid      |   16 
 drivers/block/DAC960.c                     |   27 
 drivers/message/fusion/Kconfig             |    2 
 drivers/message/fusion/Makefile            |    7 
 drivers/message/fusion/lsi/mpi.h           |    7 
 drivers/message/fusion/lsi/mpi_cnfg.h      |  131 +++
 drivers/message/fusion/lsi/mpi_history.txt |   77 +-
 drivers/message/fusion/lsi/mpi_init.h      |    7 
 drivers/message/fusion/lsi/mpi_ioc.h       |   75 ++
 drivers/message/fusion/lsi/mpi_log_sas.h   |  284 ++++----
 drivers/message/fusion/lsi/mpi_sas.h       |    9 
 drivers/message/fusion/mptbase.c           |  875 ++++++++++++++++++++-----
 drivers/message/fusion/mptbase.h           |   47 -
 drivers/message/fusion/mptctl.c            |  163 +---
 drivers/message/fusion/mptctl.h            |    2 
 drivers/message/fusion/mptfc.c             |   53 -
 drivers/message/fusion/mptlan.c            |    1 
 drivers/message/fusion/mptlan.h            |    1 
 drivers/message/fusion/mptsas.c            |  718 ++++++++++++++++----
 drivers/message/fusion/mptscsih.c          |  997 ++++++++++-------------------
 drivers/message/fusion/mptscsih.h          |   44 +
 drivers/message/fusion/mptspi.c            |  527 +++++++++++++--
 drivers/s390/scsi/zfcp_erp.c               |   22 
 drivers/s390/scsi/zfcp_ext.h               |    2 
 drivers/s390/scsi/zfcp_fsf.c               |   23 
 drivers/scsi/53c700.c                      |   24 
 drivers/scsi/53c700.h                      |    2 
 drivers/scsi/53c7xx.c                      |    4 
 drivers/scsi/BusLogic.c                    |   46 -
 drivers/scsi/BusLogic.h                    |  300 ++++----
 drivers/scsi/FlashPoint.c                  |    4 
 drivers/scsi/Kconfig                       |    9 
 drivers/scsi/Makefile                      |    1 
 drivers/scsi/NCR_D700.c                    |    1 
 drivers/scsi/aacraid/Makefile              |    2 
 drivers/scsi/aacraid/aachba.c              |  602 +++++++++--------
 drivers/scsi/aacraid/aacraid.h             |   46 +
 drivers/scsi/aacraid/comminit.c            |   14 
 drivers/scsi/aacraid/commsup.c             |   40 -
 drivers/scsi/aacraid/linit.c               |   17 
 drivers/scsi/aacraid/nark.c                |   87 ++
 drivers/scsi/aacraid/rkt.c                 |   64 +
 drivers/scsi/aacraid/rx.c                  |  263 ++++---
 drivers/scsi/aacraid/sa.c                  |   33 
 drivers/scsi/advansys.c                    |    7 
 drivers/scsi/aic7xxx/aic79xx.h             |    3 
 drivers/scsi/aic7xxx/aic79xx_core.c        |    5 
 drivers/scsi/aic7xxx/aic79xx_osm.c         |    9 
 drivers/scsi/aic7xxx/aic79xx_osm.h         |    2 
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c     |   19 
 drivers/scsi/aic7xxx/aic79xx_pci.c         |    2 
 drivers/scsi/aic94xx/aic94xx_dev.c         |   16 
 drivers/scsi/aic94xx/aic94xx_dump.c        |    2 
 drivers/scsi/aic94xx/aic94xx_init.c        |   49 -
 drivers/scsi/aic94xx/aic94xx_reg_def.h     |    5 
 drivers/scsi/aic94xx/aic94xx_sas.h         |    1 
 drivers/scsi/aic94xx/aic94xx_scb.c         |  122 +--
 drivers/scsi/aic94xx/aic94xx_sds.c         |   10 
 drivers/scsi/aic94xx/aic94xx_seq.c         |   45 +
 drivers/scsi/aic94xx/aic94xx_seq.h         |    1 
 drivers/scsi/aic94xx/aic94xx_task.c        |    9 
 drivers/scsi/aic94xx/aic94xx_tmf.c         |    4 
 drivers/scsi/ipr.c                         |   91 +-
 drivers/scsi/ipr.h                         |    4 
 drivers/scsi/lasi700.c                     |    1 
 drivers/scsi/libsas/sas_discover.c         |   62 +
 drivers/scsi/libsas/sas_event.c            |    6 
 drivers/scsi/libsas/sas_expander.c         |   48 +
 drivers/scsi/libsas/sas_init.c             |   52 +
 drivers/scsi/libsas/sas_internal.h         |    9 
 drivers/scsi/libsas/sas_port.c             |   14 
 drivers/scsi/libsas/sas_scsi_host.c        |  290 ++++++--
 drivers/scsi/megaraid/mbox_defs.h          |    2 
 drivers/scsi/megaraid/mega_common.h        |  122 +--
 drivers/scsi/megaraid/megaraid_ioctl.h     |   36 -
 drivers/scsi/megaraid/megaraid_mbox.c      |  421 +++++++-----
 drivers/scsi/megaraid/megaraid_mbox.h      |   46 -
 drivers/scsi/megaraid/megaraid_mm.c        |   65 -
 drivers/scsi/megaraid/megaraid_sas.h       |   14 
 drivers/scsi/pcmcia/nsp_cs.h               |   66 -
 drivers/scsi/qla2xxx/qla_attr.c            |   68 +
 drivers/scsi/qla2xxx/qla_def.h             |   38 +
 drivers/scsi/qla2xxx/qla_gbl.h             |    6 
 drivers/scsi/qla2xxx/qla_init.c            |  218 +-----
 drivers/scsi/qla2xxx/qla_isr.c             |  245 ++++++-
 drivers/scsi/qla2xxx/qla_mbx.c             |   18 
 drivers/scsi/qla2xxx/qla_os.c              |   24 
 drivers/scsi/qla2xxx/qla_sup.c             |  348 ++++++++++
 drivers/scsi/qla2xxx/qla_version.h         |    2 
 drivers/scsi/scsi.c                        |   21 
 drivers/scsi/scsi_debug.c                  |   42 -
 drivers/scsi/scsi_error.c                  |  256 +++----
 drivers/scsi/scsi_lib.c                    |    4 
 drivers/scsi/scsi_priv.h                   |    6 
 drivers/scsi/scsi_scan.c                   |    2 
 drivers/scsi/scsi_transport_sas.c          |  118 ++-
 drivers/scsi/scsi_transport_spi.c          |    1 
 drivers/scsi/sim710.c                      |    1 
 drivers/scsi/sni_53c710.c                  |  159 ++++
 drivers/scsi/st.c                          |   23 
 drivers/scsi/st.h                          |    3 
 include/scsi/libsas.h                      |   19 
 include/scsi/scsi_transport_sas.h          |    3 
 include/scsi/scsi_transport_spi.h          |    1 
 104 files changed, 5827 insertions(+), 3135 deletions(-)

James


