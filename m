From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 06/15] mtd:  make device_type const
Date: Mon, 21 Aug 2017 22:12:23 +0200
Message-ID: <20170821221223.0a44fe32@bbrezillon>
References: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
        <1503130946-2854-7-git-send-email-bhumirks@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:33668 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753548AbdHUUM2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2017 16:12:28 -0400
In-Reply-To: <1503130946-2854-7-git-send-email-bhumirks@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, bp@alien8.de, mchehab@kernel.org, daniel.vetter@intel.com, jani.nikula@linux.intel.com, seanpaul@chromium.org, airlied@linux.ie, g.liakhovetski@gmx.de, tomas.winkler@intel.com, dwmw2@infradead.org, computersforpeace@gmail.com, marek.vasut@gmail.com, richard@nod.at, cyrille.pitchen@wedev4u.fr, peda@axentia.se, kishon@ti.com, bhelgaas@google.com, thierry.reding@gmail.com, jonathanh@nvidia.com, dvhart@infradead.org, andy@infradead.org, ohad@wizery.com, bjorn.andersson@linaro.org, freude@de.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jth@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com, johan@kernel.org, elder@kernel.org, gregkh@linuxfoundation.org, heikki.krogerus@linux.intel.com, linux-edac@vger

Le Sat, 19 Aug 2017 13:52:17 +0530,
Bhumika Goyal <bhumirks@gmail.com> a écrit :

> Make this const as it is only stored in the type field of a device
> structure, which is const.
> Done using Coccinelle.
> 

Applied to l2-mtd/master.

Thanks,

Boris

> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
> ---
>  drivers/mtd/mtdcore.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index f872a99..e7ea842 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -340,7 +340,7 @@ static ssize_t mtd_bbtblocks_show(struct device *dev,
>  };
>  ATTRIBUTE_GROUPS(mtd);
>  
> -static struct device_type mtd_devtype = {
> +static const struct device_type mtd_devtype = {
>  	.name		= "mtd",
>  	.groups		= mtd_groups,
>  	.release	= mtd_release,
