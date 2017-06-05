From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] Remove white spaces from fcoe.h
Date: Mon, 5 Jun 2017 11:18:48 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1706051118090.2010@hadrien>
References: <0f8b6a7b-c1d2-bc95-7970-7572991495cb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <0f8b6a7b-c1d2-bc95-7970-7572991495cb@redhat.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: "Milan P. Gandhi" <mgandhi@redhat.com>
Cc: Johannes Thumshirn <jth@kernel.org>, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Mon, 5 Jun 2017, Milan P. Gandhi wrote:

> Remove the white spaces in do/while loop used for checking fcoe
> debug logging

Is it converting spaces to tabs?  If so, saying that would be clearer.

julia

>
> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> ---
>  drivers/scsi/fcoe/fcoe.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
> index 6aa4820..7406376 100644
> --- a/drivers/scsi/fcoe/fcoe.h
> +++ b/drivers/scsi/fcoe/fcoe.h
> @@ -46,7 +46,7 @@ extern unsigned int fcoe_debug_logging;
>  #define FCOE_NETDEV_LOGGING 0x02 /* Netdevice logging */
>
>  #define FCOE_CHECK_LOGGING(LEVEL, CMD)					\
> -do {                                                            	\
> +do {									\
>  	if (unlikely(fcoe_debug_logging & LEVEL))			\
>  		do {							\
>  			CMD;						\
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
