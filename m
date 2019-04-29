From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: qedf: remove set but not used variables
Date: Mon, 29 Apr 2019 08:02:26 -0400
Message-ID: <yq1muk910kt.fsf@oracle.com>
References: <20190423144138.20428-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190423144138.20428-1-yuehaibing@huawei.com> (Yue Haibing's
        message of "Tue, 23 Apr 2019 22:41:38 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>
Cc: QLogic-Storage-Upstream@cavium.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Yue,

> From: YueHaibing <yuehaibing@huawei.com>
>
> Fixes gcc '-Wunused-but-set-variable' warnings:
>
> drivers/scsi/qedf/qedf_els.c: In function 'qedf_process_els_compl':
> drivers/scsi/qedf/qedf_els.c:149:20: warning: variable 'sc_cmd' set but not used [-Wunused-but-set-variable]
> drivers/scsi/qedf/qedf_els.c:148:28: warning: variable 'task_ctx' set but not used [-Wunused-but-set-variable]
> drivers/scsi/qedf/qedf_els.c: In function 'qedf_send_srr':
> drivers/scsi/qedf/qedf_els.c:612:6: warning: variable 'sid' set but not used [-Wunused-but-set-variable]

Applied to 5.2/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
