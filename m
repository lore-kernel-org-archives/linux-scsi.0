From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] drivers/scsi/scsi_transport_iscsi.c: Fix documentation
 os parameter
Date: Wed, 02 Nov 2011 12:23:43 -0500
Message-ID: <4EB17C9F.4030700@cs.wisc.edu>
References: <1320239837-7138-1-git-send-email-marcos.mage@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1320239837-7138-1-git-send-email-marcos.mage@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: michael@cs.wisc.edu, jbottomley@parallels.com, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, rdunlap@xenotime.net, linux-doc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/02/2011 08:17 AM, Marcos Paulo de Souza wrote:
> Fixes documentation of a parameter of iscsi_bsg_host_add function to silence to make htmldocs[
> 
> Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 1bcd65a..96029e6 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -520,7 +520,7 @@ fail_host_msg:
>  /**
>   * iscsi_bsg_host_add - Create and add the bsg hooks to receive requests
>   * @shost: shost for iscsi_host
> - * @cls_host: iscsi_cls_host adding the structures to
> + * @ihost: iscsi_cls_host adding the structures to
>   */
>  static int
>  iscsi_bsg_host_add(struct Scsi_Host *shost, struct iscsi_cls_host *ihost)

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
