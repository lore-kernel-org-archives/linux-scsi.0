From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 19/20] scsi: iscsi: world-writable sysfs priv_sess file
Date: Sun, 13 Mar 2011 03:28:03 -0500
Message-ID: <4D7C8013.3090500@cs.wisc.edu>
References: <cover.1296818921.git.segoon@openwall.com> <1ca8a99eaadde79e662573d89e4f17a20457fba0.1296818921.git.segoon@openwall.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Return-path: <open-iscsi+bncCLPJla3WGRCbgPLrBBoEx4mVJg-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1ca8a99eaadde79e662573d89e4f17a20457fba0.1296818921.git.segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Vasiliy Kulikov <segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "James E.J. Bottomley" <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 02/04/2011 06:24 AM, Vasiliy Kulikov wrote:
> Don't allow everybody to change iSCSI settings.
>
> Signed-off-by: Vasiliy Kulikov<segoon-cxoSlKxDwOJWk0Htik3J/w@public.gmane.org>
> ---
>   Compile tested only.
>
>   drivers/scsi/scsi_transport_iscsi.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index f905ecb..01543d2 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1847,7 +1847,7 @@ store_priv_session_##field(struct device *dev,				\
>   #define iscsi_priv_session_rw_attr(field, format)			\
>   	iscsi_priv_session_attr_show(field, format)			\
>   	iscsi_priv_session_attr_store(field)				\
> -static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO | S_IWUGO,		\
> +static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO | S_IWUSR,		\
>   			show_priv_session_##field,			\
>   			store_priv_session_##field)
>   iscsi_priv_session_rw_attr(recovery_tmo, "%d");


Sorry for the late reply. Messed up on my side. Patch is correct and ok 
with me. Tested here.

Acked-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
