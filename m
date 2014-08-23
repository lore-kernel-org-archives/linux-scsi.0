From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v1 0/8][SCSI] mpt3sas: Phase2 and Phase3 mpt3sas driver patch set
Date: Sat, 23 Aug 2014 17:41:34 +0530
Message-ID: <1408795902-10523-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og125.obsmtp.com ([64.18.2.28]:54688 "EHLO
	exprod7og125.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbaHWMMT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Aug 2014 08:12:19 -0400
Received: by mail-pd0-f181.google.com with SMTP id g10so17087688pdj.40
        for <linux-scsi@vger.kernel.org>; Sat, 23 Aug 2014 05:12:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Just resending the complete Phase2 and Phase3
mpt3sas driver patch set Reviewed by the Martin K. Petersen.
This will make easy for Christoph to pick up this patch set for next kernel release.

Thanks Martin for reviewing this patch set and helping me for tuning this patch set.

Sreekanth Reddy (8):
  [SCSI] mpt3sas: MPI2.5 Rev G (2.5.2) specifications
  [SCSI] mpt3sas: Clear PFA Status on SGPIO when PFA Drive is Removed or
    Replaced
  [SCSI] mpt3sas: Bump mpt3sas driver version to 03.100.00.00
  [SCSI] mpt3sas: MPI2.5 Rev H (2.5.3) specifications
  [SCSI] mpt3sas: Copyright in driver sources is updated for year the
    2014.
  [SCSI] mpt3sas: Added OEM branding Strings
  [SCSI] mpt3sas: Added Reply Descriptor Post Queue (RDPQ) Array support
  [SCSI] mpt3sas: Bump mpt3sas driver version to 04.100.00.00

 drivers/scsi/mpt3sas/Kconfig                |   2 +-
 drivers/scsi/mpt3sas/mpi/mpi2.h             |   8 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h        |  18 +-
 drivers/scsi/mpt3sas/mpi/mpi2_init.h        |   8 +-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h         |  64 ++++++-
 drivers/scsi/mpt3sas/mpi/mpi2_raid.h        |   8 +-
 drivers/scsi/mpt3sas/mpi/mpi2_sas.h         |   8 +-
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h        |  45 ++++-
 drivers/scsi/mpt3sas/mpi/mpi2_type.h        |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         | 280 ++++++++++++++++++++++------
 drivers/scsi/mpt3sas/mpt3sas_base.h         |  49 ++++-
 drivers/scsi/mpt3sas/mpt3sas_config.c       |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h          |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_debug.h        |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  69 +++++--
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h |   2 +-
 19 files changed, 470 insertions(+), 105 deletions(-)

-- 
2.0.2

