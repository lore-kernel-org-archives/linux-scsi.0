From: David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH V5 5/5] add xen pvscsi maintainer
Date: Tue, 26 Aug 2014 15:14:05 +0100
Message-ID: <53FC962D.8070409@citrix.com>
References: <1408354310-6362-1-git-send-email-jgross@suse.com> <1408354310-6362-6-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1408354310-6362-6-git-send-email-jgross@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: jgross@suse.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, JBeulich@suse.com, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

On 18/08/14 10:31, jgross@suse.com wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> Add myself as maintainer for the Xen pvSCSI stuff.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index aefa948..360f86f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10086,6 +10086,14 @@ S:	Supported
>  F:	drivers/block/xen-blkback/*
>  F:	drivers/block/xen*
>  
> +XEN PVSCSI DRIVERS
> +M:	Juergen Gross <jgross@suse.com>
> +L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)

You should add the appropriate scsi list here
(linux-scsi@vger.kernel.org I presume?)

David

> +S:	Supported
> +F:	drivers/scsi/xen-scsifront.c
> +F:	drivers/xen/xen-scsiback.c
> +F:	include/xen/interface/io/vscsiif.h
> +
>  XEN SWIOTLB SUBSYSTEM
>  M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>  L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
> 
