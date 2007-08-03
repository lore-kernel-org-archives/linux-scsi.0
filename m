From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 45] drivers/scsi/lpfc/lpfc_init.c: kmalloc + memset conversion
 to kcalloc
Date: Fri, 03 Aug 2007 11:41:16 -0400
Message-ID: <46B34C9C.2050300@emulex.com>
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200707312026.43947.m.kozlowski@tuxland.pl>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <200707312026.43947.m.kozlowski@tuxland.pl>
Sender: kernel-janitors-owner@vger.kernel.org
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ACK

-- james s

Mariusz Kozlowski wrote:
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/scsi/lpfc/lpfc_init.c | 65932 -> 65881 (-51 bytes)
>  drivers/scsi/lpfc/lpfc_init.o | 219760 -> 219616 (-144 bytes)
> 
>  drivers/scsi/lpfc/lpfc_init.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- linux-2.6.23-rc1-mm1-a/drivers/scsi/lpfc/lpfc_init.c	2007-07-26 13:07:42.000000000 +0200
> +++ linux-2.6.23-rc1-mm1-b/drivers/scsi/lpfc/lpfc_init.c	2007-07-31 11:07:59.000000000 +0200
> @@ -1280,11 +1280,10 @@ lpfc_hba_init(struct lpfc_hba *phba, uin
>  	uint32_t *HashWorking;
>  	uint32_t *pwwnn = (uint32_t *) phba->wwnn;
> 
> -	HashWorking = kmalloc(80 * sizeof(uint32_t), GFP_KERNEL);
> +	HashWorking = kcalloc(80, sizeof(uint32_t), GFP_KERNEL);
>  	if (!HashWorking)
>  		return;
> 
> -	memset(HashWorking, 0, (80 * sizeof(uint32_t)));
>  	HashWorking[0] = HashWorking[78] = *pwwnn++;
>  	HashWorking[1] = HashWorking[79] = *pwwnn;
> 
> 
