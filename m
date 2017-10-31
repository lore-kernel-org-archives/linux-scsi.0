From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH 1/2] scsi: megaraid: Remove redundant code in megasas_alloc_cmds
Date: Tue, 31 Oct 2017 23:06:18 +0530
Message-ID: <5501933ac4d2773c529357265e4b2c73@mail.gmail.com>
References: <1508925428-51660-1-git-send-email-xieyisheng1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508925428-51660-1-git-send-email-xieyisheng1@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yisheng Xie <xieyisheng1@huawei.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----Original Message-----
From: Yisheng Xie [mailto:xieyisheng1@huawei.com]
Sent: Wednesday, October 25, 2017 3:27 PM
To: kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
shivasharan.srikanteshwara@broadcom.com; jejb@linux.vnet.ibm.com;
martin.petersen@oracle.com
Cc: megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; Yisheng Xie
Subject: [PATCH 1/2] scsi: megaraid: Remove redundant code in
megasas_alloc_cmds

megasas_alloc_cmds is to alloc cmd_list of instance instead of fusion, and
fusion is useless in this function. Just remove it.

Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
b/drivers/scsi/megaraid/megaraid_sas_base.c
index e518dad..0640168 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4033,9 +4033,7 @@ int megasas_alloc_cmds(struct megasas_instance
*instance)
 	int j;
 	u16 max_cmd;
 	struct megasas_cmd *cmd;
-	struct fusion_context *fusion;

-	fusion = instance->ctrl_context;
 	max_cmd = instance->max_mfi_cmds;

 	/*
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

--
1.7.12.4
