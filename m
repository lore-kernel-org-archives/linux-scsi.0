From: Evan Green <evgreen@chromium.org>
Subject: [PATCH 0/7] Enable UFS provisioning via Linux
Date: Tue, 29 May 2018 11:17:33 -0700
Message-ID: <20180529181740.195362-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Gwendal Grignou <gwendal@chromium.org>, Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

This series enables provisioning UFS devices using the existing sysfs
interface. This functionality is primarily useful along the assembly
line, but might also be useful for end users that receive devices that
aren't locked down.

Evan Green (7):
  scsi: ufs: Add Configuration Descriptor to sysfs
  scsi: ufs: Add config descriptor documentation
  scsi: ufs: Make sysfs attributes writable
  scsi: ufs: sysfs: Document attribute writability
  scsi: ufs: Refactor descriptor read for write
  scsi: ufs: Enable writing config descriptor
  scsi: ufs: Update config descriptor documentation

 Documentation/ABI/testing/sysfs-driver-ufs | 174 ++++++++++++++++++++---
 drivers/scsi/ufs/ufs-sysfs.c               | 217 ++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufs.h                     |  29 ++++
 drivers/scsi/ufs/ufshcd.c                  |  89 ++++++++----
 drivers/scsi/ufs/ufshcd.h                  |  16 ++-
 5 files changed, 458 insertions(+), 67 deletions(-)

-- 
2.13.5
