From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI updates for 2.6.25
Date: Fri, 18 Apr 2008 12:41:56 -0500
Message-ID: <1208540517.3063.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759056AbYDRRm0@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is the first piece of our merge for the merge window.  I have a bit
of other stuff with dependent patches, and I'm sure there will be
something else crawling out of the woodwork.

It's the usual grab bag of driver updates and mid-layer changes.
There's no new stand out features in this one.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short change log is:

Adrian Bunk (5):
      qla1280: remove version check
      sun3_scsi_vme: add MODULE_LICENSE
      st: rename flush_write_buffer()
      aic94xx: cleanups
      make scsi_end_bidi_request() static

Al Viro (1):
      libsas: fix endianness bug in sas_ata

Andi Kleen (1):
      Remove random noop unchecked_isa_dma users

Andrew Vasquez (15):
      qla2xxx: Update version number to 8.02.01-k1.
      qla2xxx: Remove unused member (dma_handle) from srb_t structure.
      qla2xxx: Add midlayer target/device reset support.
      qla2xxx: Check alternate 'reason' code during GPSC status handling.
      qla2xxx: Add Flash Descriptor Table layout support.
      qla2xxx: Use PCI-SIG nomenclature for PCIe bandwidth units.
      qla2xxx: Cruft cleanup of functions and structures.
      qla2xxx: Add hardware trace-logging support.
      qla2xxx: Add FC-transport Asynchronous Event Notification support.
      qla2xxx: Simplify interrupt handler locking.
      qla2xxx: Use an rport's scsi_target_id member consistently throughout driv
      qla2xxx: Remove unused and obsolete #define's.
      qla2xxx: Add support for host supported speeds FC transport attribute.
      qla2xxx: Update copyright banner.
      qla2xxx: Update firmware filenames for new ISP parts.

Boaz Harrosh (4):
      iscsi: bidi support for iscsi_tcp
      iscsi: bidi support at the generic libiscsi level
      iscsi: extended cdb support
      gdth: remove command accessors

Christof Schmitt (5):
      zfcp: Fix error handling for blocked unit for send FCP command
      zfcp: Remove zfcp_erp_wait from slave destory handler to fix deadlock
      zfcp: Move DBF definitions to private header file
      zfcp: Fix handling for boxed port after physical close
      zfcp: convert zfcp to use target reset and device reset handler

Darrick J. Wong (2):
      aic94xx: Use sas_request_addr() to provide SAS WWN if the adapter lacks on
      libsas: Provide a transport-level facility to request SAS addrs

David C Somayajulu (1):
      qla4xxx: fix scsi command completion, lun reset and target reset code

Denis Cheng (2):
      hosts.c: removed one unneeded shost->active_mode assignment
      3w-9xxx, 3w-xxxx: memset not needed in probe

FUJITA Tomonori (40):
      bsg: no need to set BSG_F_BLOCK bit in bsg_complete_all_commands
      bsg: remove minor in struct bsg_device
      bsg: use better helper list functions
      bsg: replace kobject_get with blk_get_queue
      bsg: takes a ref to struct device in fops->open
      tgt: use KMEM_CACHE macro
      scsi_debug: remove unnecessary function declarations
      scsi_debug: support large non-fake virtual disk
      scsi_debug: remove the duplicated code in resp_read and resp_write
      scsi_debug: sweep up sdebug_capacity calculation
      scsi_debug: remove unnecessary sdebug_store_size
      scsi_debug: fix lba and data length calculation bugs
      ps3rom: use scsi_build_sense_buffer
      stex: use scsi_build_sense_buffer
      libata: use scsi_build_sense_buffer
      scsi_debug: use scsi_build_sense_buffer
      add scsi_build_sense_buffer helper function
      scsi_debug: remove unnecessary function declarations
      scsi_debug: use list_for_each_entry_safe
      scsi_debug: remove unnecessary condition test in devInfoReg
      scsi_debug: create new scsi_debug devices at a single place
      scsi_debug: remove temporary hack around sscanf for negative values
      3w-9xxx: use sg buffer copy helper functions
      3w-xxxx: use sg buffer copy helper functions
      stex: use sg buffer copy helper functions
      aacraid: use sg buffer copy helper functions
      ips: use sg buffer copy helper funcitons
      simscsi: use sg buffer copy helper funcitons
      ps3rom: use sg buffer copy helper funcitons
      scsi_debug: use sg buffer copy helper functions
      scsi: add wrapper functions for sg buffer copy helper functions
      block: add sg buffer copy helper functions
      aic79xx: fix IOMMU mapping failure handling
      aic7xxx: fix IOMMU mapping failure handling
      scsi_debug: use shost_priv macro
      scsi_debug: remove unnecessary checking
      scsi_debug: remove scsi_debug.h
      scsi_debug: stop including drivers/scsi/scsi.h
      aacraid: READ_CAPACITY_16 shouldn't trust allocation length in cdb
      ips: sg chaining support to the path to non I/O commands

Geert Uytterhoeven (1):
      ps3rom: Simplify fill_from_dev_buffer()

Grant Grundler (1):
      initio: fix big endian problems for auto request sense

Harihara Kadayam (1):
      qla2xxx: Add ISP84XX support.

Harvey Harrison (1):
      ch: fix sparse shadowed variable warnings

James Bottomley (9):
      ips: remove spurious cpu_to_leX on outX statements
      libsas: fix missing inlines in header file
      transport_class: BUG if we can't release the attribute container
      fix barrier failure issue
      hptiop: fix header.context usage
      wd33c93: fix up cut and paste error
      mpt fusion: fix up msi_enable in mpt_suspend
      export command allocation and freeing functions independently of the host
      consolidate command allocation in a single place

James Smart (4):
      lpfc 8.2.6 : Update lpfc driver version to 8.2.6
      lpfc 8.2.6 : Miscellaneous Fixes
      lpfc 8.2.6 : PCI Parity and EEH handling fixes
      lpfc 8.2.6 : Multiple discovery fixes

Jeff Garzik (2):
      gdth: convert to PCI hotplug API
      gdth: PCI probe cleanups, prep for PCI hotplug API conversion

Kai Makisara (2):
      st: show options currently set in sysfs
      st: add option to use SILI in variable block reads

Marcin Slusarz (1):
      aacraid, ips: leX_add_cpu conversion

Mark Salyzyn (1):
      aacraid: Fix down_interruptible() to check the return value

Martin Peschke (21):
      zfcp: fix 31 bit compile warnings
      zfcp: fix compiler warning caused by poking inside new semaphore (linux-ne
      zfcp: Add docbook comments to debug trace.
      zfcp: Cleanup line breaks in debug trace.
      zfcp: Shorten excessive names in debug trace.
      zfcp: Simplify zfcp_dbf_tag and related functions in debug trace.
      zfcp: Simplify usage of hex dump output function for debug trace.
      zfcp: Remove obsolete output function from debug trace.
      zfcp: Cleanup debug trace view functions.
      zfcp: simplify zfcp_dbf_timestamp()
      zfcp: Remove obsolete erp_dbf trace
      zfcp: Add trace records for recovery actions.
      zfcp: Trace all triggers of error recovery activity
      zfcp: Add traces for state changes.
      zfcp: Add trace records for recovery thread and its queues
      zfcp: Register new recovery trace.
      zfcp: Introduce printf helper functions for debug trace.
      zfcp: Add qtcb dump to hba debug trace
      zfcp: Remove qtcb dump to kernel log
      zfcp: Clean up _zfcp_san_dbf_event_common_els
      zfcp: Introduce a helper function that dumps hex data to a zfcp trace.

Matthew Wilcox (1):
      BusLogic: make FlashPoint support x86-32 only

Matthias Kaehlcke (1):
      mpt fusion: convert inactive_list_mutex to a mutex

Michael Reed (1):
      mptsas: do not use ioc->handle to locate hba portinfo structure

Mike Christie (2):
      qla4xxx: Add target reset functionality
      scsi_error: add target reset handler

Paul Bolle (1):
      aacraid: Do not describe check_reset parameter with its value

Prakash, Sathya (1):
      mpt fusion: Enable MSI by default for SAS controllers

Ravi Anand (1):
      qla2xxx: Assign mailbox command timeout values in a consistent manner.

Roel Kluin (1):
      aic7xxx: Test opcode, not definition in aicasm:type_check()

Seokmann Ju (4):
      qla2xxx: Correct vport configuration-change handling.
      qla2xxx: Use proper HA during asynchrounous event handling.
      qla2xxx: Check DFLG_NO_CABLE only on physical port.
      qla2xxx: Consistently access the physical HA port.

Thomas Bogendoerfer (1):
      WD33C93: let platform stub override no_sync/fast/dma_mode

bo yang (3):
      megaraid_sas: Add the new controller(1078DE) support to the driver
      megaraid_sas: Fix the frame count calculation
      megaraid_sas: rollback the sense info implementation

and the diffstat:

 Documentation/scsi/st.txt                 |   12 
 arch/ia64/hp/sim/simscsi.c                |   23 
 block/bsg.c                               |   52 -
 drivers/ata/libata-scsi.c                 |    6 
 drivers/base/transport_class.c            |    3 
 drivers/message/fusion/mptbase.c          |   29 
 drivers/message/fusion/mptbase.h          |    5 
 drivers/message/fusion/mptsas.c           |   22 
 drivers/message/fusion/mptscsih.c         |    8 
 drivers/s390/scsi/zfcp_aux.c              |   33 
 drivers/s390/scsi/zfcp_ccw.c              |   24 
 drivers/s390/scsi/zfcp_dbf.c              | 1281 ++++++++++++++++++------------
 drivers/s390/scsi/zfcp_dbf.h              |  228 +++++
 drivers/s390/scsi/zfcp_def.h              |  169 ---
 drivers/s390/scsi/zfcp_erp.c              |  688 +++++-----------
 drivers/s390/scsi/zfcp_ext.h              |   59 -
 drivers/s390/scsi/zfcp_fsf.c              |  397 ++-------
 drivers/s390/scsi/zfcp_qdio.c             |    7 
 drivers/s390/scsi/zfcp_scsi.c             |   69 -
 drivers/s390/scsi/zfcp_sysfs_adapter.c    |   11 
 drivers/s390/scsi/zfcp_sysfs_port.c       |    9 
 drivers/s390/scsi/zfcp_sysfs_unit.c       |    5 
 drivers/scsi/3w-9xxx.c                    |   23 
 drivers/scsi/3w-xxxx.c                    |   14 
 drivers/scsi/BusLogic.c                   |    5 
 drivers/scsi/BusLogic.h                   |   21 
 drivers/scsi/FlashPoint.c                 |    6 
 drivers/scsi/Kconfig                      |   14 
 drivers/scsi/a2091.c                      |    3 
 drivers/scsi/a3000.c                      |    3 
 drivers/scsi/aacraid/aachba.c             |   69 -
 drivers/scsi/aacraid/commsup.c            |   10 
 drivers/scsi/aic7xxx/aic79xx_osm.c        |    7 
 drivers/scsi/aic7xxx/aic7xxx_osm.c        |   10 
 drivers/scsi/aic7xxx/aicasm/aicasm_gram.y |    2 
 drivers/scsi/aic94xx/aic94xx.h            |   16 
 drivers/scsi/aic94xx/aic94xx_dev.c        |    8 
 drivers/scsi/aic94xx/aic94xx_dump.c       |   10 
 drivers/scsi/aic94xx/aic94xx_dump.h       |    9 
 drivers/scsi/aic94xx/aic94xx_hwi.c        |   44 -
 drivers/scsi/aic94xx/aic94xx_hwi.h        |    2 
 drivers/scsi/aic94xx/aic94xx_init.c       |   10 
 drivers/scsi/aic94xx/aic94xx_reg.c        |   53 -
 drivers/scsi/aic94xx/aic94xx_scb.c        |   33 
 drivers/scsi/aic94xx/aic94xx_sds.c        |    4 
 drivers/scsi/aic94xx/aic94xx_seq.c        |   31 
 drivers/scsi/aic94xx/aic94xx_seq.h        |    4 
 drivers/scsi/aic94xx/aic94xx_task.c       |   12 
 drivers/scsi/aic94xx/aic94xx_tmf.c        |    2 
 drivers/scsi/arm/acornscsi.c              |    1 
 drivers/scsi/arm/cumana_1.c               |    1 
 drivers/scsi/ch.c                         |   33 
 drivers/scsi/dc395x.c                     |    1 
 drivers/scsi/eata_pio.c                   |    2 
 drivers/scsi/gdth.c                       |  320 +++----
 drivers/scsi/gdth.h                       |    2 
 drivers/scsi/gvp11.c                      |    3 
 drivers/scsi/hosts.c                      |    1 
 drivers/scsi/hptiop.c                     |    7 
 drivers/scsi/initio.c                     |    9 
 drivers/scsi/ips.c                        |   89 --
 drivers/scsi/iscsi_tcp.c                  |   31 
 drivers/scsi/libiscsi.c                   |  140 ++-
 drivers/scsi/libsas/sas_ata.c             |    2 
 drivers/scsi/libsas/sas_scsi_host.c       |   41 
 drivers/scsi/lpfc/lpfc.h                  |    5 
 drivers/scsi/lpfc/lpfc_attr.c             |   10 
 drivers/scsi/lpfc/lpfc_ct.c               |   48 -
 drivers/scsi/lpfc/lpfc_debugfs.c          |    2 
 drivers/scsi/lpfc/lpfc_els.c              |  121 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c          |   73 -
 drivers/scsi/lpfc/lpfc_init.c             |   98 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c        |   40 
 drivers/scsi/lpfc/lpfc_scsi.c             |   34 
 drivers/scsi/lpfc/lpfc_sli.c              |  112 +-
 drivers/scsi/lpfc/lpfc_version.h          |    2 
 drivers/scsi/lpfc/lpfc_vport.c            |    3 
 drivers/scsi/mac_scsi.c                   |    1 
 drivers/scsi/megaraid/megaraid_sas.c      |   49 -
 drivers/scsi/megaraid/megaraid_sas.h      |    5 
 drivers/scsi/mvme147.c                    |    3 
 drivers/scsi/ps3rom.c                     |  101 --
 drivers/scsi/qla1280.c                    |    5 
 drivers/scsi/qla2xxx/Kconfig              |    3 
 drivers/scsi/qla2xxx/qla_attr.c           |   36 
 drivers/scsi/qla2xxx/qla_dbg.c            |  124 --
 drivers/scsi/qla2xxx/qla_dbg.h            |   23 
 drivers/scsi/qla2xxx/qla_def.h            |   78 +
 drivers/scsi/qla2xxx/qla_dfs.c            |    2 
 drivers/scsi/qla2xxx/qla_fw.h             |  173 +++-
 drivers/scsi/qla2xxx/qla_gbl.h            |   33 
 drivers/scsi/qla2xxx/qla_gs.c             |   16 
 drivers/scsi/qla2xxx/qla_init.c           |  192 +++-
 drivers/scsi/qla2xxx/qla_inline.h         |   87 --
 drivers/scsi/qla2xxx/qla_iocb.c           |    5 
 drivers/scsi/qla2xxx/qla_isr.c            |  223 ++---
 drivers/scsi/qla2xxx/qla_mbx.c            |  318 +++++--
 drivers/scsi/qla2xxx/qla_mid.c            |   30 
 drivers/scsi/qla2xxx/qla_os.c             |  443 +++++-----
 drivers/scsi/qla2xxx/qla_settings.h       |   16 
 drivers/scsi/qla2xxx/qla_sup.c            |  315 +++++--
 drivers/scsi/qla2xxx/qla_version.h        |    6 
 drivers/scsi/qla4xxx/ql4_fw.h             |    4 
 drivers/scsi/qla4xxx/ql4_glbl.h           |    4 
 drivers/scsi/qla4xxx/ql4_iocb.c           |   14 
 drivers/scsi/qla4xxx/ql4_isr.c            |   40 
 drivers/scsi/qla4xxx/ql4_mbx.c            |   39 
 drivers/scsi/qla4xxx/ql4_os.c             |   96 +-
 drivers/scsi/raid_class.c                 |    2 
 drivers/scsi/scsi.c                       |  229 +++--
 drivers/scsi/scsi_debug.c                 | 1219 ++++++++++++----------------
 drivers/scsi/scsi_debug.h                 |   24 
 drivers/scsi/scsi_error.c                 |  150 +++
 drivers/scsi/scsi_lib.c                   |   12 
 drivers/scsi/scsi_tgt_lib.c               |    4 
 drivers/scsi/sgiwd93.c                    |    7 
 drivers/scsi/st.c                         |   89 +-
 drivers/scsi/st.h                         |    3 
 drivers/scsi/st_options.h                 |    6 
 drivers/scsi/stex.c                       |   83 -
 drivers/scsi/sun3_scsi_vme.c              |    1 
 drivers/scsi/wd33c93.c                    |    3 
 include/linux/attribute_container.h       |    2 
 include/linux/mtio.h                      |    1 
 include/linux/scatterlist.h               |    5 
 include/linux/transport_class.h           |    5 
 include/scsi/iscsi_proto.h                |    6 
 include/scsi/libsas.h                     |    2 
 include/scsi/sas_ata.h                    |    4 
 include/scsi/scsi_cmnd.h                  |   17 
 include/scsi/scsi_eh.h                    |    5 
 include/scsi/scsi_host.h                  |    1 
 lib/scatterlist.c                         |  102 ++
 133 files changed, 4873 insertions(+), 4389 deletions(-)

James
