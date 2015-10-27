From: Weidong Wang <wangweidong1@huawei.com>
Subject: [PATCH 0/3] megaraid_sas: copule of fixes
Date: Tue, 27 Oct 2015 16:26:12 +0800
Message-ID: <1445934375-17784-1-git-send-email-wangweidong1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, JBottomley@odin.com
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, wangweidong1@huawei.com
List-Id: linux-scsi@vger.kernel.org

Fix some checkpatch Warnings.
Fix a NULL pointer dereference.

As well kernel >=3.0.y will have the 'NULL pointer dereference'.

Weidong Wang (3):
  megaraid_sas: Convert dev_printk to dev_<level>
  megaraid_sas: Convert printk to printk_<level>
  megaraid_sas: return -ENOMEM when create DMA pool for cmd frames
    failed

 drivers/scsi/megaraid/megaraid_sas_base.c | 83 ++++++++++++++++---------------
 1 file changed, 42 insertions(+), 41 deletions(-)

-- 
1.9.0
