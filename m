From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH][next] scsi: lpfc: make several unions static, fix
 non-ANSI prototype
Date: Tue, 13 Mar 2018 09:29:34 -0700
Message-ID: <566b5646-80a8-bca3-5f35-d78a97960ed2@broadcom.com>
References: <20180313120849.30128-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180313120849.30128-1-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 3/13/2018 5:08 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> There are several unions that are local to the source and do not need
> to be in global scope, so make them static. Also add in a missing void
> parameter to functions lpfc_nvme_cmd_template and
> lpfc_nvmet_cmd_template to clean up non-ANSI warning.
>
> Cleans up sparse warnings:
> drivers/scsi/lpfc/lpfc_nvme.c:68:19: warning: symbol
> 'lpfc_iread_cmd_template' was not declared. Should it be static?
> drivers/scsi/lpfc/lpfc_nvme.c:69:19: warning: symbol
> 'lpfc_iwrite_cmd_template' was not declared. Should it be static?
> drivers/scsi/lpfc/lpfc_nvme.c:70:19: warning: symbol
> 'lpfc_icmnd_cmd_template' was not declared. Should it be static?
> drivers/scsi/lpfc/lpfc_nvme.c:74:24: warning: non-ANSI function
> 'lpfc_tsend_cmd_template' was not declared. Should it be static?
> drivers/scsi/lpfc/lpfc_nvmet.c:78:19: warning: symbol
> 'lpfc_treceive_cmd_template' was not declared. Should it be static?
> drivers/scsi/lpfc/lpfc_nvmet.c:79:19: warning: symbol
> 'lpfc_trsp_cmd_template' was not declared. Should it be static?
> drivers/scsi/lpfc/lpfc_nvmet.c:83:25: warning: non-ANSI function
> declaration of function 'lpfc_nvmet_cmd_template'
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/scsi/lpfc/lpfc_nvme.c  | 8 ++++----
>   drivers/scsi/lpfc/lpfc_nvmet.c | 8 ++++----
>   2 files changed, 8 insertions(+), 8 deletions(-)
>
>

Signed-off-by:   James Smart <james.smart@broadcom.com>
