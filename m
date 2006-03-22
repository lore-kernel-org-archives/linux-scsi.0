From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 01/15] libata: Setup nbytes in ata_sg_init_one
Date: Tue, 21 Mar 2006 20:46:57 -0500
Message-ID: <4420AC91.4070007@pobox.com>
References: <200603172303.k2HN3voJ028508@d01av02.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200603172303.k2HN3voJ028508@d01av02.pok.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Brian King wrote:
> Setup nbytes in ata_sg_init_one to the total transfer length
> of the command.
> 
> Signed-off-by: Brian King <brking@us.ibm.com>
> ---
> 
>  libata-dev-bjking1/drivers/scsi/libata-core.c |    1 +
>  1 files changed, 1 insertion(+)
> 
> diff -puN drivers/scsi/libata-core.c~libata_setup_nbytes drivers/scsi/libata-core.c
> --- libata-dev/drivers/scsi/libata-core.c~libata_setup_nbytes	2006-03-17 15:35:26.000000000 -0600
> +++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-03-17 15:35:26.000000000 -0600
> @@ -2887,6 +2887,7 @@ void ata_sg_init_one(struct ata_queued_c
>  	qc->n_elem = 1;
>  	qc->orig_n_elem = 1;
>  	qc->buf_virt = buf;
> +	qc->nbytes = buflen;

Why?

This is largely an internal variable used by the ATAPI code.

	Jeff



