From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] first set of SCSI updates for the 2.6.30 merge window
Date: Fri, 27 Mar 2009 17:30:29 +0000
Message-ID: <1238175029.3292.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53769 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753116AbZC0Rae (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2009 13:30:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is the first slice of updates.  It contains the mp2sas driver and
the libosd library plus other assorted enhancements.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Aaro Koskinen (1):
      sym53c8xx: Keep transfer negotiations valid

Adam Radford (1):
      3w-9xxx: add power management support

Alan Stern (2):
      fix /proc memory leak in the SCSI core
      sd: tell the user when a disk's capacity is adjusted

Boaz Harrosh (17):
      libosd: Fix NULL dereference BUG when target is not OSD conformant
      scsi: Add osd library to build system
      osd: Kconfig file for in-tree builds
      osd: Documentation for OSD library
      libosd: SCSI/OSD Sense decoding support
      libosd: OSDv2 auto detection
      libosd: OSD version 2 Support
      libosd: Not implemented commands
      libosd: Add Flush and List-objects support
      libosd: OSD Security processing stubs
      libosd: attributes Support
      osd_uld: API for retrieving osd devices from Kernel
      osd_uld: OSD scsi ULD
      libosd: OSDv1 preliminary implementation
      libosd: OSDv1 Headers
      add OSD_TYPE
      major.h: char-major number for OSD device driver

Brian King (1):
      ibmvfc: Better handle other FC initiators

Chauhan, Vijay (3):
      scsi_dh_rdac: Retry for NOT_READY check condition
      scsi_dh_rdac: Retry mode select for NO_SENSE, ABORTED_COMMAND, UNIT_ATTENTION, NOT_READY(02/04/01)
      scsi_dh_rdac: Retry for Quiescence in Progress in rdac device handler

Chris Leech (2):
      net: define feature flags for FCoE offloads
      net: reclaim 8 upper bits of the netdev->features from GSO

Christof Schmitt (11):
      zfcp: Report fc_host_port_type as NPIV
      zfcp: Block FC transport rports early on errors
      zfcp: Remove PCI flag
      zfcp: Send ELS ADISC from workqueue
      zfcp: Improve reliability of SCSI eh handlers in zfcp
      zfcp: Wait for free SBALs when possible
      zfcp: Only increment req_id for successfully issued requests
      zfcp: Simplify latency lock handling
      zfcp: Remove UNIT_REGISTERED status flag
      zfcp: Remove some port flags
      scsi_transport_fc: Add missing parenthesis to Point-To-Point description

Douglas Gilbert (1):
      bsg: add linux/types.h include to bsg.h

Ed Lin - PTU (5):
      stex: Version update
      stex: Small fixes
      stex: Fix for controller type st_yosemite
      stex: Add new device id
      stex: Fix for potential invalid response

Eric Moore (3):
      mpt2sas: make global symbols unique
      mpt2sas v00.100.11.15
      mpt2sas: add MPT2SAS_MINOR(221) to miscdevice.h

FUJITA Tomonori (8):
      sg: remove the own list management for struct sg_fd
      sg: use ALIGN macro
      sg: remove unnecessary function declarations
      sg: avoid blk_put_request/blk_rq_unmap_user in interrupt
      remove scsi_req_map_sg
      osst: replace scsi_execute_async with the block layer API
      osst: make all the buffer the same size
      libfc: fix compile warning

Hannes Reinecke (1):
      Check for deleted device in scsi_device_online()

Ilgu Hong (3):
      scsi dh alua: handle report luns data changed in check sense callout
      scsi dh alua: add intel Multi-Flex device
      scsi dh alua: fix group id masking

James Bottomley (2):
      Make scsi.h independent of the rest of the scsi includes
      osst: Remove SUGGEST flags

Jan Engelhardt (1):
      lpfc: constify virtual function tables

Jean Delvare (1):
      libiscsi: fix iscsi pool error path

Julia Lawall (1):
      libfc: Correct use of ! and &

Karen Xie (1):
      cxgb3i: fix function descriptions

Martin K. Petersen (3):
      sd: Make revalidate less chatty
      Remove SUGGEST flags
      scsi_debug: DIF/DIX support

Martin Peschke (1):
      zfcp: add measurement data for average qdio queue utilisation

Martin Petermann (1):
      zfcp: erp failed status bit will not be set

Matthew Wilcox (4):
      sd: Try READ CAPACITY 16 first for SBC-2 devices
      sd: Refactor sd_read_capacity()
      ses: Use new scsi VPD helper
      Add VPD helper

Mike Christie (11):
      libiscsi: fix possbile null ptr session command cleanup
      iscsi class: remove host no argument from session creation callout
      libiscsi: pass session failure a session struct
      iscsi lib: remove qdepth param from iscsi host allocation
      iscsi lib: have lib create work queue for transmitting IO
      iscsi class: fix lock dep warning on logout
      libiscsi: don't cap queue depth in iscsi modules
      iscsi_tcp: replace scsi_debug/tcp_debug logging with iscsi conn logging
      libiscsi_tcp: replace tcp_debug/scsi_debug logging with session/conn logging
      libiscsi: replace scsi_debug logging with session/conn logging
      iser: have iser use its own logging

Pete Wyckoff (1):
      iscsi tcp: bidi capable

Randy Dunlap (3):
      libfc: needs CRC32
      scsi_debug: needs CRC_T10DIF
      scsi_sysfs: delete extra kernel-doc

Robert Love (1):
      Improve SCSI_LOGGING Kconfig entry

Roel Kluin (1):
      ses: code_set == 1 is tested twice

Scott James Remnant (1):
      ch: Add scsi type modalias

Swen Schillig (6):
      zfcp: Ensure all work is cancelled on adapter dequeue
      zfcp: fix queue, scheduled work processing.
      zfcp: incorrect reaction on incoming RSCN
      zfcp: replace current ERP logging with a more convenient version
      zfcp: prevent adapter close on initial adapter open
      zfcp: remove undefined subtype for status read response

Tony Battersby (9):
      sym53c8xx: don't flood syslog with negotiation messages
      sym53c8xx: use a queue depth of 1 for untagged devices
      sym53c8xx: handle pci_iomap() failures
      sym53c8xx: unmap pci memory after probe errors
      sym53c8xx: fix bogus free_irq() on error path
      sym53c8xx: fix NULL deref on error path
      sym53c8xx: fix shost use-after-free and memory leak
      sg: fix races with ioctl(SG_IO)
      sg: fix races during device removal

Wayne Boyer (3):
      ipr: Expose debug and fastfail parameters
      ipr: add message to error table
      ipr: add MSI support

Yi Zou (9):
      fcoe: fcoe fc crc offload indication by skb->ip_summed
      fcoe: add support to FCoE offload support in fcoe_sw through net_device
      libfc: add support of large receive offload by ddp in fc_fcp
      fcoe: add support to large send by gso through net_device for fcoe_sw
      libfc: use lso_max for sequence offload
      fcoe, libfc: check offload features from LLD through netdev
      net: add FCoE offload support through net_device
      net: add NETIF_F_FCOE_CRC to can_checksum_protocol
      net, fcoe: add ETH_P_FCOE for Fibre Channel over Ethernet (FCoE)

and the diffstat:

 Documentation/devices.txt                    |    6 
 Documentation/scsi/osd.txt                   |  198 
 MAINTAINERS                                  |   10 
 block/cmd-filter.c                           |    1 
 drivers/infiniband/ulp/iser/iscsi_iser.c     |   17 
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    2 
 drivers/infiniband/ulp/iser/iser_initiator.c |    2 
 drivers/net/xen-netfront.c                   |    2 
 drivers/s390/scsi/zfcp_aux.c                 |   24 
 drivers/s390/scsi/zfcp_ccw.c                 |   24 
 drivers/s390/scsi/zfcp_dbf.c                 |  188 
 drivers/s390/scsi/zfcp_dbf.h                 |    3 
 drivers/s390/scsi/zfcp_def.h                 |   17 
 drivers/s390/scsi/zfcp_erp.c                 |  290 -
 drivers/s390/scsi/zfcp_ext.h                 |   73 
 drivers/s390/scsi/zfcp_fc.c                  |   82 
 drivers/s390/scsi/zfcp_fsf.c                 |  240 -
 drivers/s390/scsi/zfcp_fsf.h                 |    4 
 drivers/s390/scsi/zfcp_qdio.c                |   47 
 drivers/s390/scsi/zfcp_scsi.c                |  250 -
 drivers/s390/scsi/zfcp_sysfs.c               |   20 
 drivers/scsi/3w-9xxx.c                       |  101 
 drivers/scsi/3w-9xxx.h                       |    2 
 drivers/scsi/Kconfig                         |   18 
 drivers/scsi/Makefile                        |    3 
 drivers/scsi/ch.c                            |    1 
 drivers/scsi/constants.c                     |   13 
 drivers/scsi/cxgb3i/cxgb3i_ddp.c             |    5 
 drivers/scsi/cxgb3i/cxgb3i_ddp.h             |    8 
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c           |   27 
 drivers/scsi/cxgb3i/cxgb3i_offload.c         |    3 
 drivers/scsi/cxgb3i/cxgb3i_offload.h         |    1 
 drivers/scsi/cxgb3i/cxgb3i_pdu.c             |    2 
 drivers/scsi/device_handler/scsi_dh_alua.c   |   14 
 drivers/scsi/device_handler/scsi_dh_rdac.c   |   49 
 drivers/scsi/fcoe/fcoe_sw.c                  |   67 
 drivers/scsi/fcoe/libfcoe.c                  |   16 
 drivers/scsi/hosts.c                         |    3 
 drivers/scsi/hptiop.c                        |    3 
 drivers/scsi/ibmvscsi/ibmvfc.c               |   62 
 drivers/scsi/ipr.c                           |   13 
 drivers/scsi/ipr.h                           |    4 
 drivers/scsi/ips.c                           |    3 
 drivers/scsi/iscsi_tcp.c                     |   73 
 drivers/scsi/libfc/fc_exch.c                 |    6 
 drivers/scsi/libfc/fc_fcp.c                  |   75 
 drivers/scsi/libfc/fc_lport.c                |    5 
 drivers/scsi/libfc/fc_rport.c                |    2 
 drivers/scsi/libiscsi.c                      |  236 -
 drivers/scsi/libiscsi_tcp.c                  |  122 
 drivers/scsi/lpfc/lpfc_debugfs.c             |   16 
 drivers/scsi/lpfc/lpfc_scsi.c                |    6 
 drivers/scsi/mpt2sas/Kconfig                 |   66 
 drivers/scsi/mpt2sas/Makefile                |    7 
 drivers/scsi/mpt2sas/mpi/mpi2.h              | 1067 +++++
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h         | 2151 ++++++++++
 drivers/scsi/mpt2sas/mpi/mpi2_init.h         |  420 +
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h          | 1295 ++++++
 drivers/scsi/mpt2sas/mpi/mpi2_raid.h         |  295 +
 drivers/scsi/mpt2sas/mpi/mpi2_sas.h          |  282 +
 drivers/scsi/mpt2sas/mpi/mpi2_tool.h         |  249 +
 drivers/scsi/mpt2sas/mpi/mpi2_type.h         |   61 
 drivers/scsi/mpt2sas/mpt2sas_base.c          | 3435 ++++++++++++++++
 drivers/scsi/mpt2sas/mpt2sas_base.h          |  779 +++
 drivers/scsi/mpt2sas/mpt2sas_config.c        | 1873 ++++++++
 drivers/scsi/mpt2sas/mpt2sas_ctl.c           | 2516 +++++++++++
 drivers/scsi/mpt2sas/mpt2sas_ctl.h           |  416 +
 drivers/scsi/mpt2sas/mpt2sas_debug.h         |  181 
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         | 5687 +++++++++++++++++++++++++++
 drivers/scsi/mpt2sas/mpt2sas_transport.c     | 1211 +++++
 drivers/scsi/osd/Kbuild                      |   45 
 drivers/scsi/osd/Kconfig                     |   53 
 drivers/scsi/osd/Makefile                    |   37 
 drivers/scsi/osd/osd_debug.h                 |   30 
 drivers/scsi/osd/osd_initiator.c             | 1657 +++++++
 drivers/scsi/osd/osd_uld.c                   |  487 ++
 drivers/scsi/osst.c                          |   96 
 drivers/scsi/osst.h                          |    2 
 drivers/scsi/scsi.c                          |  104 
 drivers/scsi/scsi_debug.c                    |  443 ++
 drivers/scsi/scsi_error.c                    |   34 
 drivers/scsi/scsi_lib.c                      |  203 
 drivers/scsi/scsi_scan.c                     |    1 
 drivers/scsi/scsi_sysfs.c                    |    1 
 drivers/scsi/scsi_transport_fc.c             |    2 
 drivers/scsi/scsi_transport_iscsi.c          |   45 
 drivers/scsi/sd.c                            |  349 +
 drivers/scsi/sd.h                            |    1 
 drivers/scsi/ses.c                           |   33 
 drivers/scsi/sg.c                            |  495 +-
 drivers/scsi/st.c                            |    6 
 drivers/scsi/stex.c                          |  107 
 drivers/scsi/sym53c8xx_2/sym_glue.c          |  137 
 drivers/scsi/sym53c8xx_2/sym_hipd.c          |   64 
 drivers/scsi/sym53c8xx_2/sym_hipd.h          |    4 
 drivers/usb/storage/transport.c              |    2 
 include/linux/bsg.h                          |    2 
 include/linux/if_ether.h                     |    1 
 include/linux/major.h                        |    1 
 include/linux/miscdevice.h                   |    1 
 include/linux/netdevice.h                    |   18 
 include/linux/skbuff.h                       |    2 
 include/scsi/fc/fc_fcoe.h                    |    7 
 include/scsi/fc_frame.h                      |   19 
 include/scsi/libfc.h                         |   31 
 include/scsi/libfcoe.h                       |   18 
 include/scsi/libiscsi.h                      |   19 
 include/scsi/osd_attributes.h                |  327 +
 include/scsi/osd_initiator.h                 |  433 ++
 include/scsi/osd_protocol.h                  |  579 ++
 include/scsi/osd_sec.h                       |   45 
 include/scsi/osd_sense.h                     |  260 +
 include/scsi/osd_types.h                     |   40 
 include/scsi/scsi.h                          |   31 
 include/scsi/scsi_cmnd.h                     |   15 
 include/scsi/scsi_device.h                   |   10 
 include/scsi/scsi_transport_iscsi.h          |    4 
 net/core/dev.c                               |    4 
 118 files changed, 28866 insertions(+), 1889 deletions(-)

James


