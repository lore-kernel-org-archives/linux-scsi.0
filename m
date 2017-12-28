From: chenxiang <chenxiang66@hisilicon.com>
Subject: [PATCH 0/2] Change frame type for SET MAX commands
Date: Thu, 28 Dec 2017 18:20:45 +0800
Message-ID: <1514456447-213928-1-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: martin.petersen@oracle.com, tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linuxarm@huawei.com, chenxiang <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

According to ATA protocol, there are two other values for SET MAX commands' 
feature field. So definite them. Also those SET MAX commands belong to 
different frame types,and judge feature field of SET MAX commands to decide
which frame type they belongs to.

chenxiang (2):
  ata: enhance the definition of SET MAX feature field value
  scsi: hisi_sas: Change frame type for SET MAX commands

 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 20 ++++++++++++++++++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  2 +-
 include/linux/ata.h                    |  2 ++
 5 files changed, 24 insertions(+), 5 deletions(-)

-- 
1.9.1

