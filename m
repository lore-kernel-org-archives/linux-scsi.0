From: Vasu Dev <vasu.dev-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] [trivial] scsi:fcoe: Fix typo "a ethernet"
 in fcoe_transport.c
Date: Tue, 23 Jun 2015 10:00:07 -0700
Message-ID: <1435078807.4179.173.camel@lin-nd1-054.jf.intel.com>
References: <1433346874-11261-1-git-send-email-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1433346874-11261-1-git-send-email-standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, JBottomley-wo1vFcy6AUs@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-06-04 at 00:54 +0900, Masanari Iida wrote:
> This patch fix some "a ethernet" in MODULE_DESCRIPTIONS in
> fcoe_transport.c
> 
> Signed-off-by: Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/scsi/fcoe/fcoe_transport.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
> index bdc8989..d7597c0 100644
> --- a/drivers/scsi/fcoe/fcoe_transport.c
> +++ b/drivers/scsi/fcoe/fcoe_transport.c
> @@ -58,7 +58,7 @@ MODULE_PARM_DESC(show, " Show attached FCoE transports");
>  module_param_call(create, fcoe_transport_create, NULL,
>  		  (void *)FIP_MODE_FABRIC, S_IWUSR);
>  __MODULE_PARM_TYPE(create, "string");
> -MODULE_PARM_DESC(create, " Creates fcoe instance on a ethernet interface");
> +MODULE_PARM_DESC(create, " Creates fcoe instance on an ethernet interface");
>  
>  module_param_call(create_vn2vn, fcoe_transport_create, NULL,
>  		  (void *)FIP_MODE_VN2VN, S_IWUSR);
> @@ -68,15 +68,15 @@ MODULE_PARM_DESC(create_vn2vn, " Creates a VN_node to VN_node FCoE instance "
>  
>  module_param_call(destroy, fcoe_transport_destroy, NULL, NULL, S_IWUSR);
>  __MODULE_PARM_TYPE(destroy, "string");
> -MODULE_PARM_DESC(destroy, " Destroys fcoe instance on a ethernet interface");
> +MODULE_PARM_DESC(destroy, " Destroys fcoe instance on an ethernet interface");
>  
>  module_param_call(enable, fcoe_transport_enable, NULL, NULL, S_IWUSR);
>  __MODULE_PARM_TYPE(enable, "string");
> -MODULE_PARM_DESC(enable, " Enables fcoe on a ethernet interface.");
> +MODULE_PARM_DESC(enable, " Enables fcoe on an ethernet interface.");
>  
>  module_param_call(disable, fcoe_transport_disable, NULL, NULL, S_IWUSR);
>  __MODULE_PARM_TYPE(disable, "string");
> -MODULE_PARM_DESC(disable, " Disables fcoe on a ethernet interface.");
> +MODULE_PARM_DESC(disable, " Disables fcoe on an ethernet interface.");
>  
>  /* notification function for packets from net device */
>  static struct notifier_block libfcoe_notifier = {

I don't this patch applied yet, Looks good.

Acked-by: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
