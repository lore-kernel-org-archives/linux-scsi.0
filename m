From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [Resend 0/2] mpt3sas: Add support to Aero controllers.
Date: Thu, 25 Oct 2018 19:33:39 +0530
Message-ID: <1540476221-14987-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Suganath Prabu <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

1) Updated MPI headers to the latest version 2.6.7.
2) Added support for Aero/Sea controllers.

Suganath Prabu (2):
  mpt3sas: Update MPI headers to support Aero controllers.
  mpt3sas: Add support to Aero PCI IDs.

 drivers/scsi/mpt3sas/mpi/mpi2.h       |  17 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h  |  94 +++++--
 drivers/scsi/mpt3sas/mpi/mpi2_image.h | 507 ++++++++++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpi/mpi2_init.h  |   2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h   | 359 +-----------------------
 drivers/scsi/mpt3sas/mpi/mpi2_pci.h   |  11 +-
 drivers/scsi/mpt3sas/mpi/mpi2_raid.h  |   2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_sas.h   |   2 +-
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h  |  72 ++++-
 drivers/scsi/mpt3sas/mpt3sas_base.h   |   1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c  |  26 ++
 11 files changed, 705 insertions(+), 388 deletions(-)
 create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2_image.h

-- 
1.8.3.1
