From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: make a couple of functions static
Date: Mon, 29 May 2017 16:08:47 -0700
Message-ID: <3d1696a8-0f7b-20aa-b242-839b91cc7068@broadcom.com>
References: <20170518093524.13549-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170518093524.13549-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Patch is fine.

Signed-off-by: James Smart  <james.smart@broadcom.com>

-- james


On 5/18/2017 2:35 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> functions lpfc_nvmet_cleanup_io_context and lpfc_nvmet_setup_io_context
> can be made static as they do not need to be in global scope.
>
> Cleans up sparse warnings:
>    "warning: symbol 'lpfc_nvmet_cleanup_io_context' was not declared.
>     Should it be static?"
>    "warning: symbol 'lpfc_nvmet_setup_io_context' was not declared.
>     Should it be static?"
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>
