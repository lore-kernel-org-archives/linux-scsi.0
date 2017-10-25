From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: [PATCH 1/2] scsi: megaraid: Remove redundant code in megasas_alloc_cmds
Date: Wed, 25 Oct 2017 17:57:07 +0800
Message-ID: <1508925428-51660-1-git-send-email-xieyisheng1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Yisheng Xie <xieyisheng1@huawei.com>
List-Id: linux-scsi@vger.kernel.org

megasas_alloc_cmds is to alloc cmd_list of instance instead of fusion,
and fusion is useless in this function. Just remove it.

Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e518dad..0640168 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4033,9 +4033,7 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 	int j;
 	u16 max_cmd;
 	struct megasas_cmd *cmd;
-	struct fusion_context *fusion;
 
-	fusion = instance->ctrl_context;
 	max_cmd = instance->max_mfi_cmds;
 
 	/*
-- 
1.7.12.4
