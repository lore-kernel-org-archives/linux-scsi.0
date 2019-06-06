From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: Avoid unused function warnings
Date: Thu, 6 Jun 2019 10:08:03 -0700
Message-ID: <27ccc327-3a4b-f489-2b21-b68479e45519@broadcom.com>
References: <20190606052421.103469-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606052421.103469-1-natechancellor@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org



On 6/5/2019 10:24 PM, Nathan Chancellor wrote:
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
>
> Fixes: 4064b27417a7 ("scsi: lpfc: Make some symbols static")
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_nvmet.c | 2 ++
>   1 file changed, 2 insertions(+)
>
>

Looks fine.

Reviewed-by:  James Smart  <james.smart@broadcom.com>
