From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 08/12] IB/srp: Rearrange module description
Date: Thu, 30 Apr 2015 13:15:48 +0300
Message-ID: <554200D4.5060300@dev.mellanox.co.il>
References: <5541EE21.3050809@sandisk.com> <5541EF39.6040301@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5541EF39.6040301-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 4/30/2015 12:00 PM, Bart Van Assche wrote:
> Move the module version and release date into separate fields.
> This makes the modinfo output easier to read.
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index 8b6f166..3727b90 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -59,9 +59,10 @@
>   #define DRV_RELDATE	"July 1, 2013"
>
>   MODULE_AUTHOR("Roland Dreier");
> -MODULE_DESCRIPTION("InfiniBand SCSI RDMA Protocol initiator "
> -		   "v" DRV_VERSION " (" DRV_RELDATE ")");
> +MODULE_DESCRIPTION("InfiniBand SCSI RDMA Protocol initiator");
>   MODULE_LICENSE("Dual BSD/GPL");
> +MODULE_VERSION(DRV_VERSION);
> +MODULE_INFO(release_date, DRV_RELDATE);
>
>   static unsigned int srp_sg_tablesize;
>   static unsigned int cmd_sg_entries;
>

Looks good.

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
