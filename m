From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] scsi: ncr5380: constify pnp_device_id
Date: Wed, 16 Aug 2017 17:17:43 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1708161713450.976@nippy.intranet>
References: <60c34272432b3411cd5d55728c62481e133f32a6.1502859040.git.arvind.yadav.cs@gmail.com> <1125161eb43bc7ee7f748a040ab06b40cc1537dd.1502859040.git.arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1125161eb43bc7ee7f748a040ab06b40cc1537dd.1502859040.git.arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: schmitzmic@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 16 Aug 2017, Arvind Yadav wrote:

> pnp_device_id are not supposed to change at runtime. All functions
> working with pnp_device_id provided by <linux/pnp.h> work with
> const pnp_device_id. So mark the non-const structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Acked-by: Finn Thain <fthain@telegraphics.com.au>

> ---
>  drivers/scsi/g_NCR5380.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index c34fc91..1968d81 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -703,7 +703,7 @@ static struct isa_driver generic_NCR5380_isa_driver = {
>  };
>  
>  #ifdef CONFIG_PNP
> -static struct pnp_device_id generic_NCR5380_pnp_ids[] = {
> +static const struct pnp_device_id generic_NCR5380_pnp_ids[] = {
>  	{ .id = "DTC436e", .driver_data = BOARD_DTC3181E },
>  	{ .id = "" }
>  };
> 
