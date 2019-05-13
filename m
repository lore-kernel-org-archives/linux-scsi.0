From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: qedi: remove set but not used variables 'cdev' and 'udev'
Date: Mon, 13 May 2019 18:33:02 -0400
Message-ID: <yq18svagf35.fsf@oracle.com>
References: <20190424080256.30012-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190424080256.30012-1-yuehaibing@huawei.com> (Yue Haibing's
        message of "Wed, 24 Apr 2019 16:02:56 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>
Cc: QLogic-Storage-Upstream@cavium.com, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Yue,

> From: YueHaibing <yuehaibing@huawei.com>
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/scsi/qedi/qedi_iscsi.c: In function 'qedi_ep_connect':
> drivers/scsi/qedi/qedi_iscsi.c:813:23: warning: variable 'udev' set but not used [-Wunused-but-set-variable]
> drivers/scsi/qedi/qedi_iscsi.c:812:18: warning: variable 'cdev' set but not used [-Wunused-but-set-variable]

Applied to 5.2/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
