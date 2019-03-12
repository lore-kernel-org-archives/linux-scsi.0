From: Dongli Zhang <dongli.zhang@oracle.com>
Subject: [PATCH 0/4] scsi: cleanup hardcoding by replacing 0 by HCTX_TYPE_DEFAULT
Date: Tue, 12 Mar 2019 09:00:27 +0800
Message-ID: <1552352431-18821-1-git-send-email-dongli.zhang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com, linux-kernel@vger.kernel.org
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, don.brace@microsemi.com, esc.storagedev@microsemi.com, dongli.zhang@oracle.com
List-Id: linux-scsi@vger.kernel.org

As in commit 7d76f8562f4c ("blk-mq: use HCTX_TYPE_DEFAULT but not 0 to
index blk_mq_tag_set->map"), this patch set cleanup driver/scsi/* to index
blk_mq_tag_set->map[] with HCTX_TYPE_DEFAULT, but not 0.

 drivers/scsi/qla2xxx/qla_os.c         | 2 +-
 drivers/scsi/scsi_lib.c               | 2 +-
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 drivers/scsi/virtio_scsi.c            | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

Dongli Zhang
