From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: Avoid unused function warnings
Date: Thu, 06 Jun 2019 17:55:16 -0400
Message-ID: <yq1sgsmmla3.fsf@oracle.com>
References: <20190606052421.103469-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606052421.103469-1-natechancellor@gmail.com> (Nathan
        Chancellor's message of "Wed, 5 Jun 2019 22:24:21 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org


Nathan,

> When building powerpc pseries_defconfig or powernv_defconfig:
>
> drivers/scsi/lpfc/lpfc_nvmet.c:224:1: error: unused function
> 'lpfc_nvmet_get_ctx_for_xri' [-Werror,-Wunused-function]
> drivers/scsi/lpfc/lpfc_nvmet.c:246:1: error: unused function
> 'lpfc_nvmet_get_ctx_for_oxid' [-Werror,-Wunused-function]
>
> These functions are only compiled when CONFIG_NVME_TARGET_FC is enabled.
> Use that same condition so there is no more warning. While the fixes
> commit did not introduce these functions, it caused these warnings.

Applied to 5.3/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
