From: James.Smart@Emulex.Com
Subject: RE: [2.6 patch] drivers/scsi/lpfc/lpfc_scsi.c: make lpfc_sli_get_scsi_buf() static
Date: Mon, 21 Nov 2005 12:29:50 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276C18@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:62120 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932395AbVKURhe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Nov 2005 12:37:34 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bunk@stusta.de
Cc: linux-scsi@vger.kernel.org

looks fine...

-- james s

> -----Original Message-----
> From: Adrian Bunk [mailto:bunk@stusta.de]
> Sent: Sunday, November 20, 2005 5:51 PM
> To: Smart, James
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [2.6 patch] drivers/scsi/lpfc/lpfc_scsi.c: make
> lpfc_sli_get_scsi_buf() static
> 
> 
> This patch makes the needlessly global function 
> lpfc_sli_get_scsi_buf() 
> static.
> 
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> --- 
> linux-2.6.15-rc1-mm2-full/drivers/scsi/lpfc/lpfc_scsi.c.old	
> 2005-11-20 19:52:28.000000000 +0100
> +++ linux-2.6.15-rc1-mm2-full/drivers/scsi/lpfc/lpfc_scsi.c	
> 2005-11-20 19:52:45.000000000 +0100
> @@ -136,7 +136,7 @@
>  	return psb;
>  }
>  
> -struct  lpfc_scsi_buf*
> +static struct lpfc_scsi_buf*
>  lpfc_sli_get_scsi_buf(struct lpfc_hba * phba)
>  {
>  	struct  lpfc_scsi_buf * lpfc_cmd = NULL;
> 
> 
