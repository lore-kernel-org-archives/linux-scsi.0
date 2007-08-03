From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 46] drivers/scsi/lpfc/lpfc_scsi.c: kmalloc + memset conversion
 to kzalloc
Date: Fri, 03 Aug 2007 11:41:26 -0400
Message-ID: <46B34CA6.6010502@emulex.com>
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200707312027.55149.m.kozlowski@tuxland.pl>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <200707312027.55149.m.kozlowski@tuxland.pl>
Sender: kernel-janitors-owner@vger.kernel.org
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ACK

-- james s

Mariusz Kozlowski wrote:
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/scsi/lpfc/lpfc_scsi.c | 42769 -> 42721 (-48 bytes)
>  drivers/scsi/lpfc/lpfc_scsi.o | 191332 -> 191240 (-92 bytes)
> 
>  drivers/scsi/lpfc/lpfc_scsi.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- linux-2.6.23-rc1-mm1-a/drivers/scsi/lpfc/lpfc_scsi.c	2007-07-26 13:07:42.000000000 +0200
> +++ linux-2.6.23-rc1-mm1-b/drivers/scsi/lpfc/lpfc_scsi.c	2007-07-31 11:08:46.000000000 +0200
> @@ -208,10 +208,9 @@ lpfc_new_scsi_buf(struct lpfc_vport *vpo
>  	dma_addr_t pdma_phys;
>  	uint16_t iotag;
> 
> -	psb = kmalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
> +	psb = kzalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
>  	if (!psb)
>  		return NULL;
> -	memset(psb, 0, sizeof (struct lpfc_scsi_buf));
> 
>  	/*
>  	 * Get memory from the pci pool to map the virt space to pci bus space
> 
