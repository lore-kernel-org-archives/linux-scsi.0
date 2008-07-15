From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI part 1
Date: Tue, 15 Jul 2008 11:15:42 -0500
Message-ID: <1216138543.3312.60.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60095 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753547AbYGOQPs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2008 12:15:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is the accumulated SCSI patches for the merge window.  If your
patch isn't in, don't worry, that'll be for part 2.  There was a bit of
an uptick in patches last week, so I haven't got around to reviewing and
merging them all (plus they need to incubate for a bit too).

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Adrian Bunk (2):
      make struct scsi_{host,target}_type static
      mpt fusion: make struct mpt_proc_root_dir static

Alan Stern (1):
      SCSI: remove dev->power.power_state from mesh driver

Alexander Beregalov (1):
      scsi_cmnd.h: remove double inclusion of linux/blkdev.h

Benjamin Herrenschmidt (1):
      sym53c8xx: Fix bogus sym_que_entry re-implementation of container_of

Boaz Harrosh (1):
      iscsi_tcp: Enable any size command

Brian King (2):
      ibmvfc: IBM Power Virtual Fibre Channel Adapter Client Driver
      sg: Add target reset support

Chandra Seetharaman (9):
      scsi_dh: fix kconfig related build errors
      scsi_dh: Remove hardware handler infrastructure from dm
      scsi_dh: Remove hardware handlers from dm
      scsi_dh: Remove dm_pg_init_complete
      scsi_dh: Add a single threaded workqueue for initializing paths
      scsi_dh: Use SCSI device handler in dm-multipath
      scsi_dh: add EMC Clariion device handler
      scsi_dh: add lsi rdac device handler
      scsi_dh: add infrastructure for SCSI Device Handlers

Christof Schmitt (13):
      zfcp: Cleanup external header file
      zfcp: Cleanup code in zfcp_erp.c
      zfcp: Small QDIO cleanups
      zfcp: Fix error checking for ELS ADISC requests
      zfcp: Message cleanup
      zfcp: Cleanup code in zfcp_ccw
      zfcp: Move CFDC code to new file.
      zfcp: Move FC code to new file
      zfcp: Fix sparse warning by providing new entry in dbf
      zfcp: Remove some sparse warnings
      zfcp: Fix mempool pointer for GID_PN request allocation
      zfcp: sysfs attributes for fabric and channel latencies
      zfcp: Track fabric and channel latencies provided by FCP adapter

David S. Miller (1):
      esp: Correct chip ID probing sequence.

FUJITA Tomonori (1):
      bsg: fix bsg_mutex hang with device removal

Frans Pop (1):
      esp: correct module name in Kconfig help for SCSI_SUNESP

Harvey Harrison (3):
      scsi: use get_unaligned_* helpers
      Replace __FUNCTION__ with __func__ in iscsi_tcp.
      aacraid: linit.c make aac_show_serial_number static

Heiko Carstens (1):
      zfcp: Fix fsf_status_read return code handling

James Bottomley (2):
      fix locking in host use of blk_plug_device()
      make use of the residue value

James Smart (5):
      lpfc 8.2.7 : Update version to 8.2.7
      lpfc 8.2.7 : Miscellaneous Fixes
      lpfc 8.2.7 : Rework the worker thread
      lpfc 8.2.7 : Discovery Fixes
      lpfc 8.2.7 : Change device reset behavior

Mark Salyzyn (2):
      aacraid: prevent copy_from_user() BUG!
      aacraid: Add Power Management cards to documentation

Martin K. Petersen (5):
      lib: Add support for the T10 (SCSI) Data Integrity Field CRC
      sd: Move scsi_disk() accessor function to sd.h
      sd: Move sd.h header file
      Rename scsi_bidi_sdb_cache
      scsi_debug: Runtime-configurable sector size

Martin Peschke (7):
      zfcp: Remove sysfs attribute port_add
      zfcp: remove some __attribute__ ((packed))
      zfcp: Refine trace levels of some recovery related events.
      zfcp: Add information about interrupt to trace.
      zfcp: Rename sbal_curr to sbal_last.
      zfcp: Rename sbal_last.
      zfcp: Remove field sbal_last from trace record.

Martin Petermann (2):
      zfcp: Cleanup of code in zfcp_scsi.c
      zfcp: Move status accessors from zfcp to SCSI include file.

Matthew Wilcox (1):
      scsi_debug: add support for rotation speed

Mike Christie (28):
      iscsi class: fix endpoint leak
      iscsi class: update version number
      libiscsi, iscsi_tcp, ib_iser: fix setting of can_queue with old tools.
      iscsi class: fix refcount leak
      libiscsi, iser, tcp: remove recv_lock
      libiscsi: fix cmds_max setting
      iscsi class: Add session initiatorname and ifacename sysfs attrs.
      iscsi_tcp: hook iscsi_tcp into iscsi_endpoint code
      iser: Modify iser to take a iscsi_endpoint struct in ep callouts and sessi
      iscsi class: add endpoint class
      iscsi class: user device_for_each_child instead of duplicating session lis
      iser: handle iscsi_cmd_task rename
      iscsi_tcp: handle iscsi_cmd_task rename
      libiscsi: rename iscsi_cmd_task to iscsi_task
      iser: convert ib_iser to support merged tasks
      iscsi_tcp: convert iscsi_tcp to support merged tasks
      libiscsi: merge iscsi_mgmt_task and iscsi_cmd_task
      libiscsi: modify libiscsi so it supports offloaded data paths
      libiscsi, iscsi_tcp, iser: add session cmds array accessor
      iser: fix handling of scsi cmnds during recovery.
      iscsi: modify iscsi printk so it can take driver data pointers
      iscsi: remove session/conn_data_size from iscsi_transport
      iscsi: add iscsi host helpers
      iscsi: remove session and host binding in libiscsi
      iscsi class: rename iscsi_host to iscsi_cls_host
      iscsi class, iscsi drivers: remove unused iscsi_transport attrs
      iscsi class, iscsi_tcp/iser: add host arg to session creation
      scsi_dh: add hp sw device handler

Prakash, Sathya (4):
      mpt fusion : Adding FAULT Reset polling work
      mpt fusion : Setting intial period to 0xFF instead of 0xA
      mpt fusion : Updated copyright statment with 2008 included
      mpt fusion: Driver version upgrade to 3.04.07

Sven Schuetz (1):
      zfcp: Add port_state attribute to sysfs

Swen Schillig (8):
      zfcp: zfcp_fsf cleanup.
      zfcp: consolidate sysfs things into one file.
      zfcp: Cleanup of code in zfcp_aux.c
      zfcp: Adapter reopen for large number of unsolicited status
      zfcp: wait until adapter is finished with ERP during auto-port
      zfcp: Automatically attach remote ports
      zfcp: Cleanup qdio code
      zfcp: receiving an unsolicted status can lead to I/O stall

And the diffstat:

 Documentation/scsi/aacraid.txt               |   24 
 block/bsg.c                                  |    9 
 drivers/infiniband/ulp/iser/iscsi_iser.c     |  356 -
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   44 
 drivers/infiniband/ulp/iser/iser_initiator.c |  209 -
 drivers/infiniband/ulp/iser/iser_memory.c    |   77 
 drivers/infiniband/ulp/iser/iser_verbs.c     |   28 
 drivers/md/Kconfig                           |   23 
 drivers/md/Makefile                          |    7 
 drivers/md/dm-emc.c                          |  345 -
 drivers/md/dm-hw-handler.c                   |  213 -
 drivers/md/dm-hw-handler.h                   |   63 
 drivers/md/dm-mpath-hp-sw.c                  |  247 -
 drivers/md/dm-mpath-rdac.c                   |  700 ---
 drivers/md/dm-mpath.c                        |  163 
 drivers/md/dm-mpath.h                        |    1 
 drivers/message/fusion/lsi/mpi.h             |    2 
 drivers/message/fusion/lsi/mpi_cnfg.h        |    2 
 drivers/message/fusion/mptbase.c             |   91 
 drivers/message/fusion/mptbase.h             |   17 
 drivers/message/fusion/mptctl.c              |    4 
 drivers/message/fusion/mptctl.h              |    2 
 drivers/message/fusion/mptdebug.h            |    2 
 drivers/message/fusion/mptfc.c               |    2 
 drivers/message/fusion/mptlan.c              |    2 
 drivers/message/fusion/mptlan.h              |    2 
 drivers/message/fusion/mptsas.c              |    2 
 drivers/message/fusion/mptsas.h              |    2 
 drivers/message/fusion/mptscsih.c            |    2 
 drivers/message/fusion/mptscsih.h            |    2 
 drivers/message/fusion/mptspi.c              |    3 
 drivers/s390/scsi/Makefile                   |    3 
 drivers/s390/scsi/zfcp_aux.c                 | 1689 +-------
 drivers/s390/scsi/zfcp_ccw.c                 |  152 
 drivers/s390/scsi/zfcp_cfdc.c                |  259 +
 drivers/s390/scsi/zfcp_dbf.c                 |   90 
 drivers/s390/scsi/zfcp_dbf.h                 |   12 
 drivers/s390/scsi/zfcp_def.h                 |  341 -
 drivers/s390/scsi/zfcp_erp.c                 | 3824 +++++-------------
 drivers/s390/scsi/zfcp_ext.h                 |  301 -
 drivers/s390/scsi/zfcp_fc.c                  |  567 ++
 drivers/s390/scsi/zfcp_fsf.c                 | 5573 ++++++++-------------------
 drivers/s390/scsi/zfcp_fsf.h                 |   70 
 drivers/s390/scsi/zfcp_qdio.c                |  811 +--
 drivers/s390/scsi/zfcp_scsi.c                |  784 ---
 drivers/s390/scsi/zfcp_sysfs.c               |  496 ++
 drivers/s390/scsi/zfcp_sysfs_adapter.c       |  270 -
 drivers/s390/scsi/zfcp_sysfs_driver.c        |  106 
 drivers/s390/scsi/zfcp_sysfs_port.c          |  295 -
 drivers/s390/scsi/zfcp_sysfs_unit.c          |  167 
 drivers/scsi/Kconfig                         |   27 
 drivers/scsi/Makefile                        |    2 
 drivers/scsi/aacraid/commctrl.c              |   33 
 drivers/scsi/aacraid/linit.c                 |    2 
 drivers/scsi/device_handler/Kconfig          |   32 
 drivers/scsi/device_handler/Makefile         |    7 
 drivers/scsi/device_handler/scsi_dh.c        |  162 
 drivers/scsi/device_handler/scsi_dh_emc.c    |  499 ++
 drivers/scsi/device_handler/scsi_dh_hp_sw.c  |  202 
 drivers/scsi/device_handler/scsi_dh_rdac.c   |  691 +++
 drivers/scsi/esp_scsi.c                      |   24 
 drivers/scsi/hosts.c                         |    2 
 drivers/scsi/ibmvscsi/Makefile               |    1 
 drivers/scsi/ibmvscsi/ibmvfc.c               | 3910 ++++++++++++++++++
 drivers/scsi/ibmvscsi/ibmvfc.h               |  682 +++
 drivers/scsi/iscsi_tcp.c                     |  514 +-
 drivers/scsi/iscsi_tcp.h                     |    7 
 drivers/scsi/libiscsi.c                      | 1359 +++---
 drivers/scsi/lpfc/lpfc.h                     |   21 
 drivers/scsi/lpfc/lpfc_attr.c                |    3 
 drivers/scsi/lpfc/lpfc_crtn.h                |    3 
 drivers/scsi/lpfc/lpfc_ct.c                  |   22 
 drivers/scsi/lpfc/lpfc_els.c                 |  181 
 drivers/scsi/lpfc/lpfc_hbadisc.c             |  120 
 drivers/scsi/lpfc/lpfc_init.c                |   34 
 drivers/scsi/lpfc/lpfc_nportdisc.c           |  145 
 drivers/scsi/lpfc/lpfc_scsi.c                |  232 -
 drivers/scsi/lpfc/lpfc_sli.c                 |   49 
 drivers/scsi/lpfc/lpfc_version.h             |    2 
 drivers/scsi/lpfc/lpfc_vport.c               |   16 
 drivers/scsi/mesh.c                          |    8 
 drivers/scsi/qla4xxx/ql4_os.c                |    8 
 drivers/scsi/scsi.c                          |    9 
 drivers/scsi/scsi_debug.c                    |  110 
 drivers/scsi/scsi_error.c                    |   11 
 drivers/scsi/scsi_lib.c                      |   35 
 drivers/scsi/scsi_scan.c                     |    2 
 drivers/scsi/scsi_sysfs.c                    |    1 
 drivers/scsi/scsi_transport_iscsi.c          |  395 +
 drivers/scsi/sd.c                            |    7 
 drivers/scsi/sd.h                            |   62 
 drivers/scsi/sg.c                            |    3 
 drivers/scsi/sym53c8xx_2/sym_misc.h          |    4 
 include/linux/crc-t10dif.h                   |    8 
 include/scsi/iscsi_if.h                      |   93 
 include/scsi/iscsi_proto.h                   |    3 
 include/scsi/libiscsi.h                      |  107 
 include/scsi/scsi.h                          |   18 
 include/scsi/scsi_cmnd.h                     |    1 
 include/scsi/scsi_device.h                   |   22 
 include/scsi/scsi_dh.h                       |   69 
 include/scsi/scsi_transport_iscsi.h          |   91 
 include/scsi/sd.h                            |   57 
 include/scsi/sg.h                            |    1 
 lib/Kconfig                                  |    7 
 lib/Makefile                                 |    1 
 lib/crc-t10dif.c                             |   67 
 107 files changed, 14425 insertions(+), 14215 deletions(-)

James


