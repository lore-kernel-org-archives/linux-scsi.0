From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 0/3] constify scsi vio_device_id
Date: Thu, 17 Aug 2017 19:18:43 +0530
Message-ID: <1502977723-3207-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tyreld@linux.vnet.ibm.com, paulus@samba.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, mpe@ellerman.id.au
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

vio_device_id are not supposed to change at runtime. All functions
working with vio_device_id provided by <asm/vio.h> work with
const vio_device_id. So mark the non-const structs as const.

Arvind Yadav (3):
  [PATCH 1/3] scsi: ibmvfc: constify vio_device_id
  [PATCH 2/3] scsi: ibmvscsi: constify vio_device_id
  [PATCH 3/3] scsi: ibmvscsi_tgt: constify vio_device_id

 drivers/scsi/ibmvscsi/ibmvfc.c           | 2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c         | 2 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.7.4
