From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: megaraid_sas: Remove a bunch of set but not used variables
Date: Tue, 26 Feb 2019 10:13:42 -0500
Message-ID: <yq136oad1ll.fsf@oracle.com>
References: <20190222015858.9744-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190222015858.9744-1-yuehaibing@huawei.com> (Yue Haibing's
        message of "Fri, 22 Feb 2019 09:58:58 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Yue Haibing <yuehaibing@huawei.com>
Cc: shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com, sumit.saxena@broadcom.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com
List-Id: linux-scsi@vger.kernel.org


Yue,

> From: YueHaibing <yuehaibing@huawei.com>
>
> Fixes gcc '-Wunused-but-set-variable' warning:

Applied to 5.1/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
