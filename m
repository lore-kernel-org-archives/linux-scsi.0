From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/2 v3] be2iscsi: Fix some error messages
Date: Sat, 13 Aug 2016 04:35:44 -0700
Message-ID: <1471088144.3467.11.camel@perches.com>
References: <4cd24bc3-7953-479a-1dbe-2aac9299ce13@wanadoo.fr>
	 <1471072824-1491-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471072824-1491-1-git-send-email-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, jayamohan.kallickal@avagotech.com, jejb@linux.vnet.ibm.com, ketan.mukadam@avagotech.com, sony.john@avagotech.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2016-08-13 at 09:20 +0200, Christophe JAILLET wrote:
> This fixes:
[]
>    - concatenate strings on the same line to fix checkpatch warnings
[]
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
[]
> @@ -268,7 +268,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
>  				&nonemb_cmd.dma);
>  	if (nonemb_cmd.va == NULL) {
>  		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,
> -			    "BM_%d : Failed to allocate memory for"
> +			    "BM_%d : Failed to allocate memory for "
>  			    "mgmt_invalidate_icds\n");

doesn't match commit log as no coalescing/concatenation
is done.

There are many of these.
