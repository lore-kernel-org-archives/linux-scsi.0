From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 00/13] mpt3sas driver NVMe support:
Date: Tue, 31 Oct 2017 18:02:26 +0530
Message-ID: <1509453159-7028-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Ventura Series controller are Tri-mode. The controller and
firmware are capable of supporting NVMe devices and
PCIe switches to be connected with the controller. This
patch set adds driver level support for NVMe devices and
PCIe switches.

Suganath Prabu S (13):
  mpt3sas: Add nvme device support in slave alloc,      target  alloc
    and probe
  mpt3sas: SGL to PRP Translation for I/Os to NVMe      devices
  mpt3sas: Added support for nvme encapsulated request      message.
  mpt3sas: API 's to support NVMe drive addition to  SML
  mpt3sas: API's to remove nvme drive from sml
  mpt3sas: Handle NVMe PCIe device related events      generated from
    firmware.
  mpt3sas: Set NVMe device queue depth as 128
  mpt3sas: scan and add nvme device after controller      reset
  mpt3as: Add-Task-management-debug-info-for-NVMe-drives.
  mpt3sas: NVMe drive support for BTDHMAPPING ioctl      command and log
    info
  mpt3sas: Fix nvme drives checking for tlr.
  mpt3sas: Fix sparse warnings
  mpt3sas: Update mpt3sas driver version.

 drivers/scsi/mpt3sas/mpt3sas_base.c      |  643 ++++++++-
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  171 ++-
 drivers/scsi/mpt3sas/mpt3sas_config.c    |  100 ++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  158 ++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 2080 +++++++++++++++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |    2 +-
 7 files changed, 3054 insertions(+), 330 deletions(-)

Thanks,
Suganath Prabu S
-- 
2.5.5
