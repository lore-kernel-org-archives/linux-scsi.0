From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: double lock typo in lpfc_ns_rsp()
Date: Wed, 3 May 2017 14:46:43 -0700
Message-ID: <62ab0dcd-bf74-677d-7ee5-15a02230b2b6@broadcom.com>
References: <20170503212215.m2t2rfrkoktugkg4@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170503212215.m2t2rfrkoktugkg4@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 5/3/2017 2:22 PM, Dan Carpenter wrote:
> There is a double lock bug here so this will deadlock instead of
> unlocking.
>
> Fixes: 1c5b12f76301 ("Fix implicit logo and RSCN handling for NVMET")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
>
Yep. looks good

Reviewed-by: James Smart <james.smart@broadcom.com>


