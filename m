From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH] lpfc: fix model description
Date: Wed, 27 May 2015 23:40:09 +0200
Message-ID: <20150527234009.0000472c@localhost>
References: <20150422231618.00005ec8@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54795 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbbE0VkN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 May 2015 17:40:13 -0400
In-Reply-To: <20150422231618.00005ec8@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

I wrote:
> Remove trailing space from model description.
> 
> Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
> 
> diff -up 4.0/drivers/scsi/lpfc.orig/lpfc_init.c 4.0/drivers/scsi/lpfc/lpfc_init.c
> --- 4.0/drivers/scsi/lpfc.orig/lpfc_init.c	2015-04-15 06:18:24.673045138 +0200
> +++ 4.0/drivers/scsi/lpfc/lpfc_init.c	2015-04-22 21:03:39.203230409 +0200
> @@ -2253,7 +2253,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba
>  				phba->Port);
>  		else if (max_speed == 0)
>  			snprintf(descp, 255,
> -				"Emulex %s %s %s ",
> +				"Emulex %s %s %s",
>  				m.name, m.bus, m.function);
>  		else
>  			snprintf(descp, 255,

James,

any feedback?

Sebastian
