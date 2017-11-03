From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: fix kzalloc-simple.cocci warnings
Date: Fri, 03 Nov 2017 12:26:50 -0400
Message-ID: <yq1375v72gl.fsf@oracle.com>
References: <1507750961-26945-1-git-send-email-gomonovych@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507750961-26945-1-git-send-email-gomonovych@gmail.com> (Vasyl
        Gomonovych's message of "Wed, 11 Oct 2017 21:42:41 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Vasyl Gomonovych <gomonovych@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org


Vasyl,

> drivers/scsi/lpfc/lpfc_debugfs.c:5460:22-29: WARNING: kzalloc should be used for phba -> nvmeio_trc, instead of kmalloc/memset
> drivers/scsi/lpfc/lpfc_debugfs.c:2230:20-27: WARNING: kzalloc should be used for phba -> nvmeio_trc, instead of kmalloc/memset
>
>  Use kzalloc rather than kmalloc followed by memset with 0

Applied to 4.15/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
