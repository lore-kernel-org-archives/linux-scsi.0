From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 00/10] mpt2sas: Phase19 and Phase20 patch set
Date: Mon, 12 Jan 2015 11:38:54 +0530
Message-ID: <1421042944-14988-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:36864 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbbALGJe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2015 01:09:34 -0500
Received: by mail-pa0-f54.google.com with SMTP id fb1so30185807pad.13
        for <linux-scsi@vger.kernel.org>; Sun, 11 Jan 2015 22:09:33 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Please consider this mpt2sas drivers Phase19 and Phase20 patch series.
All these patches are reviewed by Martin K. Petersen.

Some of these features are exists for both mpt2sas & mpt3sas drives,
so some of these patches contains code changes for both mpt2sas & mpt3sas
drivers.

Sreekanth Reddy (10):
  [SCSI] mpt2sas: MPI2 Rev AA (2.00.19) specifications
  [SCSI] mpt2sas, mpt3sas: Added support to log message when Temperature
    Threshold exceeds for any Sensor
  [PATCH] mpt2sas, mpt3sas: Fail the host reset initiated due to
    discovery related I/O timeouts at driver load time
  [SCSI] mpt2sas: Bump driver version to 19.100.00.00
  [SCSI] mpt2sas: MPI2 Rev BB (2.00.20) specification and 2.00.35 header
    files
  [SCSI] mpt2sas, mpt3sas: Removing uppper boundary restriction for the
    module parameter max_sgl_entries
  [SCSI] mpt2sas: Complete the SCSI command with DID_RESET status for
    log_info value 0x0x32010081
  [SCSI] mpt2sas, mpt3sas: Update Attribution Language to Avago
  [SCSI] mpt2sas, mpt3sas: Added a support to set cpu affinity for each
    MSIX vector enabled by the HBA
  [SCSI] mpt2sas: Bump driver version to 20.100.00.00

 drivers/scsi/mpt2sas/mpi/mpi2.h             |  7 ++--
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h        | 51 ++++++++++++++++++++++++-----
 drivers/scsi/mpt2sas/mpi/mpi2_ioc.h         |  4 ++-
 drivers/scsi/mpt2sas/mpi/mpi2_tool.h        |  6 ++--
 drivers/scsi/mpt2sas/mpt2sas_base.c         | 44 +++++++++++++++++++++----
 drivers/scsi/mpt2sas/mpt2sas_base.h         | 16 ++++++---
 drivers/scsi/mpt2sas/mpt2sas_config.c       | 39 +++++++++++++++++++++-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c          |  3 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.h          |  3 +-
 drivers/scsi/mpt2sas/mpt2sas_debug.h        |  3 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        | 47 +++++++++++++++++++++++++-
 drivers/scsi/mpt2sas/mpt2sas_transport.c    |  3 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         | 45 +++++++++++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_base.h         | 12 +++++--
 drivers/scsi/mpt3sas/mpt3sas_config.c       | 39 +++++++++++++++++++++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |  3 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h          |  3 +-
 drivers/scsi/mpt3sas/mpt3sas_debug.h        |  3 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 42 +++++++++++++++++++++++-
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |  3 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |  3 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h |  3 +-
 22 files changed, 336 insertions(+), 46 deletions(-)

-- 
2.0.2

