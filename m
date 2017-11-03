From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: megaraid: Remove redundant code in megasas_alloc_cmds
Date: Fri, 03 Nov 2017 11:26:15 -0400
Message-ID: <yq1k1z7759k.fsf@oracle.com>
References: <1508925428-51660-1-git-send-email-xieyisheng1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508925428-51660-1-git-send-email-xieyisheng1@huawei.com>
        (Yisheng Xie's message of "Wed, 25 Oct 2017 17:57:07 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Yisheng Xie <xieyisheng1@huawei.com>
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Yisheng,

> megasas_alloc_cmds is to alloc cmd_list of instance instead of fusion,
> and fusion is useless in this function. Just remove it.

Applied to 4.15/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
