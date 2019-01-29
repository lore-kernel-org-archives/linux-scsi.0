From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 0/4] mpt3sas: Add Atlas and Ambrosia device support.
Date: Tue, 29 Jan 2019 07:14:39 -0500
Message-ID: <1548764083-5781-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Posting below patches to include new devices Ambrosia,
Atlas.

* Rename macros for MPI Endpoint device which
is a PCIe switch based on MPI2.
* Added device ID 0x02B1 for NVMe Switch Adapter (Ambrosia).
* Added device ID for the Atlas PCIe Switch management port
(0x00B2). This device is based on MPI2.6 and it exposes
one SES device to accept management commands.

Suganath Prabu S (4):
  mpt3sas: Rename mpi endpoint device ID macro.
  mpt3sas: Add support for NVMe Switch Adapter
  mpt3sas: Add support for ATLAS PCIe switch.
  mpt3sas: Update driver version to 27.102.00.00

 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h |  3 ++-
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  7 +++++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 16 +++++++++++++---
 3 files changed, 20 insertions(+), 6 deletions(-)

Thanks,
Suganath Prabu
-- 
1.8.3.1
