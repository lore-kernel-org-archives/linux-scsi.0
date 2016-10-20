From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH 0/2] smartpqi: Remove semaphores
Date: Thu, 20 Oct 2016 14:24:00 +0530
Message-ID: <1476953642-2160-1-git-send-email-binoy.jayan@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: kevin Barnett <kevin.barnett@microsemi.com>, Don Brace <don.brace@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

The following are a set of patches which removes semaphores from 
scsi/smartpqi. These are part of a bigger effort to eliminate all
semaphores from the linux kernel.

Thanks,
Binoy

Binoy Jayan (2):
  scsi: smartpqi: Replace semaphore sync_request_sem with mutex
  scsi: smartpqi: Replace semaphore lun_reset_sem with mutex

 drivers/scsi/smartpqi/smartpqi.h      |  6 ++++--
 drivers/scsi/smartpqi/smartpqi_init.c | 37 +++++++++--------------------------
 2 files changed, 13 insertions(+), 30 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
