From: "Ulrich Windl" <ulrich.windl-LOEJiUoeGm199bV2EpccEXqWYbMAw+HU@public.gmane.org>
Subject: Re: [PATCH] iscsi: Kconfig option for debug prints.
Date: Mon, 12 Jan 2009 16:39:32 +0100
Message-ID: <496B7248.11724.162B0F6@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
References: <496B62B8.3030402@panasas.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-reply-to: <496B62B8.3030402-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Content-description: Mail message body
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


On 12 Jan 2009 at 17:33, Boaz Harrosh wrote:

> --- a/drivers/scsi/iscsi_tcp.h
> +++ b/drivers/scsi/iscsi_tcp.h
> @@ -25,6 +25,12 @@
>  #include <scsi/libiscsi.h>
>  #include <scsi/libiscsi_tcp.h>
>  
> +#if (CONFIG_ISCSI_DEBUG & 2)
> +#define debug_tcp(fmt...) printk(KERN_INFO "tcp: " fmt)
> +#else
> +#define debug_tcp(fmt...)
> +#endif
> +

Hi!

Let me say that I feel that "tcp:" should be something like "iSCSI-TCP:", just to 
point out that it's related to iSCSI.

Regards,
Ulrich
