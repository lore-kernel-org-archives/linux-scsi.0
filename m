From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: fix a handful of indentation issues
Date: Wed, 13 Feb 2019 13:24:34 -0800
Message-ID: <318e23da-04ee-87d0-644b-c1f87a1c5316@broadcom.com>
References: <20190212152945.11362-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190212152945.11362-1-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2/12/2019 7:29 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> There are a handful of statements that are indented incorrectly. Fix these.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/scsi/lpfc/lpfc_bsg.c     | 4 ++--
>   drivers/scsi/lpfc/lpfc_debugfs.c | 4 ++--
>   drivers/scsi/lpfc/lpfc_init.c    | 2 +-
>   drivers/scsi/lpfc/lpfc_mbox.c    | 4 ++--
>   drivers/scsi/lpfc/lpfc_sli.c     | 2 +-
>   5 files changed, 8 insertions(+), 8 deletions(-)
>
>

Looks good to me.

Signed-off-by:  James Smart   <james.smart@broadcom.com>

-- james
