From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH trivial] fcoe: use defines from ethtool for
 20Gbit and 40Gbit speeds
Date: Thu, 7 Jul 2016 11:34:23 -0400 (EDT)
Message-ID: <1052325310.3376977.1467905663681.JavaMail.zimbra@redhat.com>
References: <1467898918-90352-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1467898918-90352-1-git-send-email-jthumshirn-l3A5Bk7waGM@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, Jiri Kosina <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux SCSI Mailinglist <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Johannes Thumshirn" <jthumshirn-l3A5Bk7waGM@public.gmane.org>
> To: "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "James Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Jiri Kosina"
> <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: "Linux SCSI Mailinglist" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, "Johannes Thumshirn"
> <jthumshirn-l3A5Bk7waGM@public.gmane.org>
> Sent: Thursday, July 7, 2016 9:41:58 AM
> Subject: [PATCH trivial] fcoe: use defines from ethtool for 20Gbit and 40Gbit speeds
> 
> Use defines from ethtool for 20Gbit and 40Gbit speeds instead of magic
> numbers.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
> ---
>  drivers/scsi/fcoe/fcoe_transport.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_transport.c
> b/drivers/scsi/fcoe/fcoe_transport.c
> index 641c60e..7028dd3 100644
> --- a/drivers/scsi/fcoe/fcoe_transport.c
> +++ b/drivers/scsi/fcoe/fcoe_transport.c
> @@ -133,10 +133,10 @@ int fcoe_link_speed_update(struct fc_lport *lport)
>  		case SPEED_10000:
>  			lport->link_speed = FC_PORTSPEED_10GBIT;
>  			break;
> -		case 20000:
> +		case SPEED_20000:
>  			lport->link_speed = FC_PORTSPEED_20GBIT;
>  			break;
> -		case 40000:
> +		case SPEED_40000:
>  			lport->link_speed = FC_PORTSPEED_40GBIT;
>  			break;
>  		default:
> --
> 1.8.5.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Looks fine, simple change
Reviewed-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
