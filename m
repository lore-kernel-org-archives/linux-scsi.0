From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 20/20] [SCSI] tmscsim: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 08:29:16 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1309230828030.11505@axis700.grange>
References: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
 <001801ceb7fa$772ae550$6580aff0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:62389 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3IWG3e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2013 02:29:34 -0400
In-Reply-To: <001801ceb7fa$772ae550$6580aff0$%han@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jingoo Han <jg1.han@samsung.com>
Cc: 'James Bottomley' <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org, 'Kurt Garloff' <garloff@suse.de>

On Mon, 23 Sep 2013, Jingoo Han wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure. Thus, it is not needed to manually clear the
> device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/scsi/tmscsim.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> index 9327f5f..b06a1de 100644
> --- a/drivers/scsi/tmscsim.c
> +++ b/drivers/scsi/tmscsim.c
> @@ -2553,7 +2553,6 @@ static void dc390_remove_one(struct pci_dev *dev)
>  
>  	pci_disable_device(dev);
>  	scsi_host_put(scsi_host);
> -	pci_set_drvdata(dev, NULL);
>  }
>  
>  static struct pci_device_id tmscsim_pci_tbl[] = {
> -- 
> 1.7.10.4
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
