From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [v1 0/2] mpt3sas: Add support to Aero controllers.
Date: Tue, 30 Oct 2018 12:05:14 +0530
Message-ID: <1540881316-13577-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Suganath Prabu <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

1) Updated MPI headers to the latest version 2.6.7.
2) Added support for Aero/Sea controllers.

V1 changes:
In Patch 2, 
ioc->name is populated later, so fixing ioc->name
before using it in ioc_warn. 
Enable Warning message only for aero configurable
controllers.

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
 drivers/scsi/mpt3sas/mpt3sas_scsih.c  |  30 +-
 11 files changed, 707 insertions(+), 390 deletions(-)
 create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2_image.h

-- 
1.8.3.1
