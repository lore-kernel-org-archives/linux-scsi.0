From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [2.6 patch] drivers/scsi/lpfc/lpfc_scsi.c: make lpfc_get_scsi_buf()
 static
Date: Fri, 06 Jan 2006 14:47:17 -0500
Message-ID: <43BEC945.6030905@emulex.com>
References: <20060106192128.GC12131@stusta.de>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:19074 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S964833AbWAFTy4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jan 2006 14:54:56 -0500
In-Reply-To: <20060106192128.GC12131@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

ACK - fine :)

-- james

Adrian Bunk wrote:
> This patch makes the needlessly global function lpfc_sli_get_scsi_buf()
> static.
> 
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> --- linux-2.6.15-mm1-full/drivers/scsi/lpfc/lpfc_scsi.c.old	2006-01-06 19:50:38.000000000 +0100
> +++ linux-2.6.15-mm1-full/drivers/scsi/lpfc/lpfc_scsi.c	2006-01-06 19:50:46.000000000 +0100
> @@ -150,7 +150,7 @@
>  	return psb;
>  }
>  
> -struct  lpfc_scsi_buf*
> +static struct lpfc_scsi_buf*
>  lpfc_get_scsi_buf(struct lpfc_hba * phba)
>  {
>  	struct  lpfc_scsi_buf * lpfc_cmd = NULL;
> 
> 
