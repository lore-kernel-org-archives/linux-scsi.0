From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH V5 5/5] add xen pvscsi maintainer
Date: Wed, 20 Aug 2014 09:08:37 -0400
Message-ID: <20140820130837.GC3120@laptop.dumpdata.com>
References: <1408354310-6362-1-git-send-email-jgross@suse.com>
 <1408354310-6362-6-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23386 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaHTNfz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Aug 2014 09:35:55 -0400
Content-Disposition: inline
In-Reply-To: <1408354310-6362-6-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgross@suse.com
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com, nab@linux-iscsi.org

On Mon, Aug 18, 2014 at 11:31:50AM +0200, jgross@suse.com wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> Add myself as maintainer for the Xen pvSCSI stuff.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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
> +S:	Supported
> +F:	drivers/scsi/xen-scsifront.c
> +F:	drivers/xen/xen-scsiback.c
> +F:	include/xen/interface/io/vscsiif.h
> +
>  XEN SWIOTLB SUBSYSTEM
>  M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>  L:	xen-devel@lists.xenproject.org (moderated for non-subscribers)
> -- 
> 1.8.4.5
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
