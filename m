From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] lpfc: nvmet_fc: fix format string
Date: Mon, 29 May 2017 16:02:20 -0700
Message-ID: <4367de5c-9778-a48c-f37e-0fbde57f3f15@broadcom.com>
References: <20170519080447.1043039-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170519080447.1043039-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Patch is fine.

Signed-off-by: James Smart <james.smart@broadcom.com>

-- james


On 5/19/2017 1:04 AM, Arnd Bergmann wrote:
> The lpfc_nvmeio_data() tracing helper always takes a format string and
> three additional arguments. The latest caller has a format string with
> only two integer arguments, causing this harmless warning:
>
> drivers/scsi/lpfc/lpfc_nvmet.c: In function 'lpfc_nvmet_xmt_fcp_release':
> drivers/scsi/lpfc/lpfc_nvmet.c:802:25: error: too many arguments for format [-Werror=format-extra-args]
>    lpfc_nvmeio_data(phba, "NVMET FCP FREE: xri x%x ste %d\n", ctxp->oxid,
>
> We could add a dummy argument here, but it seems reasonable to print
> the 'abort' flag as the third argument.
>
> Fixes: 19b58d9473e8 ("nvmet_fc: add req_release to lldd api")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>
