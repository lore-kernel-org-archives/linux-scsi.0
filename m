From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 00/18][SCSI] mpt2sas,mpt3sas: mpt2sas's phase17, phase18 and mpt3sas's phase2, phase3 patch set series
Date: Fri, 12 Sep 2014 15:35:15 +0530
Message-ID: <1410516333-3678-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:50110 "EHLO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaILKGT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2014 06:06:19 -0400
Received: by mail-pa0-f53.google.com with SMTP id rd3so925823pab.40
        for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2014 03:06:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Elliott@hp.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

This patch set series contains latest reviewed mpt2sas driver's Phase17 and Phase18 patches
and also mpt3sas driver's Phase2 and Phase3 patches.

Thanks Martin for reviewing all these patches.

Incremented the version to v2 for all these patches to indicate that
these are the latest patches and accommodates all the review changes.

Droped below patch from this series and I will include this patch in the
next series once the review completes on this patch

mpt2sas: Added module parameter 'unblock_io' to unblock IO's during disk addition

Sreekanth Reddy (18):
  [SCSI] mpt2sas: Added driver module parameter max_msix_vectors
  [SCSI] mpt2sas: MPI2 Rev Y (2.00.17) and Rev Z (2.00.18)
    specifications
  [SCSI] mpt2sas: Copyright in driver sources is updated for year the
    2014
  [SCSI] mpt2sas: Clear PFA Status on SGPIO when PFA Drive is Removed or
    Replaced
  [SCSI] mpt2sas: Bump mpt2sas driver version to 17.100.00.00
  [SCSI] mpt2sas: Avoid type casting for direct I/O commands
  [SCSI] mpt2sas: Added Reply Descriptor Post Queue (RDPQ) Array support
  [SCSI] mpt2sas: Get IOC_FACTS information using handshake protocol
    only after HBA card gets into READY or Operational state.
  [SCSI] mpt2sas: Bump mpt2sas driver version to 18.100.00.00
  [SCSI] mpt3sas: MPI2.5 Rev G (2.5.2) specifications
  SCSI] mpt3sas: Clear PFA Status on SGPIO when PFA Drive is Removed or
    Replaced
  [SCSI] mpt3sas: Bump mpt3sas driver version to 03.100.00.00
  [SCSI] mpt3sas: MPI2.5 Rev H (2.5.3) specifications
  [SCSI] mpt3sas: Copyright in driver sources is updated for year the
    2014.
  [SCSI] mpt3sas: Added OEM branding Strings
  [SCSI] mpt3sas: Added Reply Descriptor Post Queue (RDPQ) Array support
  [SCSI] mpt3sas: Bump mpt3sas driver version to 04.100.00.00
  [SCSI] mpt3sas, mpt2sas: fix scsi_add_host error handling problems in
    _scsih_probe

 drivers/scsi/mpt2sas/Kconfig                |   2 +-
 drivers/scsi/mpt2sas/mpi/mpi2.h             |  12 +-
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h        |  29 ++-
 drivers/scsi/mpt2sas/mpi/mpi2_init.h        |   8 +-
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h         |  74 ++++++-
 drivers/scsi/mpt2sas/mpi/mpi2_raid.h        |   8 +-
 drivers/scsi/mpt2sas/mpi/mpi2_sas.h         |   2 +-
 drivers/scsi/mpt2sas/mpi/mpi2_tool.h        |  44 +++-
 drivers/scsi/mpt2sas/mpi/mpi2_type.h        |   2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c         | 322 +++++++++++++++++++++++-----
 drivers/scsi/mpt2sas/mpt2sas_base.h         |  28 ++-
 drivers/scsi/mpt2sas/mpt2sas_config.c       |   2 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c          |   2 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.h          |   2 +-
 drivers/scsi/mpt2sas/mpt2sas_debug.h        |   2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        | 197 +++++++++--------
 drivers/scsi/mpt2sas/mpt2sas_transport.c    |   2 +-
 drivers/scsi/mpt3sas/Kconfig                |   2 +-
 drivers/scsi/mpt3sas/mpi/mpi2.h             |   8 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h        |  18 +-
 drivers/scsi/mpt3sas/mpi/mpi2_init.h        |   8 +-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h         |  64 +++++-
 drivers/scsi/mpt3sas/mpi/mpi2_raid.h        |   8 +-
 drivers/scsi/mpt3sas/mpi/mpi2_sas.h         |   8 +-
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h        |  45 +++-
 drivers/scsi/mpt3sas/mpi/mpi2_type.h        |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         | 283 +++++++++++++++++++-----
 drivers/scsi/mpt3sas/mpt3sas_base.h         |  49 ++++-
 drivers/scsi/mpt3sas/mpt3sas_config.c       |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h          |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_debug.h        |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  78 +++++--
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h |   2 +-
 36 files changed, 1026 insertions(+), 299 deletions(-)

-- 
2.0.2

