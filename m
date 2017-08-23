From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: remove useless code in
 lpfc_sli4_bsg_link_diag_test
Date: Wed, 23 Aug 2017 09:20:15 -0700
Message-ID: <bc07e4ee-0477-c91e-29f9-68d1792341de@broadcom.com>
References: <20170822205353.GA17794@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170822205353.GA17794@embeddedgus>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 8/22/2017 1:53 PM, Gustavo A. R. Silva wrote:
> Remove variable assignments. The value stored in local variable _rc_ is
> overwritten at line 2448:rc = lpfc_sli4_bsg_set_link_diag_state(phba, 0);
> before it can be used.
>
> Addresses-Coverity-ID: 1226935
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
> This issue was detected by Coverity and it was tested by compilation only.
> Notice that this code has been there since 2011.
>
>   drivers/scsi/lpfc/lpfc_bsg.c | 9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
>
>

looks good. Thanks

Signed-off-by: James Smart <james.smart@broadcom.com>

-- james
