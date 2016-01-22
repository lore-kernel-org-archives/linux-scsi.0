From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 3/3] xen-scsiback: fix license ident used in
 MODULE_LICENSE
Date: Fri, 22 Jan 2016 13:55:39 +0100
Message-ID: <56A226CB.4010101@suse.com>
References: <1453466057-7176-1-git-send-email-wei.liu2@citrix.com>
 <1453466057-7176-4-git-send-email-wei.liu2@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbcAVMzl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2016 07:55:41 -0500
In-Reply-To: <1453466057-7176-4-git-send-email-wei.liu2@citrix.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Liu <wei.liu2@citrix.com>, Xen-devel <xen-devel@lists.xenproject.org>
Cc: David Vrabel <david.vrabel@citrix.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, "open list:XEN PVSCSI DRIVERS" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

On 22/01/16 13:34, Wei Liu wrote:
> The comment at the beginning of the file is the canonical source of
> licenses for this module. Currently it contains GPL and MIT license.
> Fix the code to reflect the reality.
> 
> Signed-off-by: Wei Liu <wei.liu2@citrix.com>

Acked-by: Juergen Gross <jgross@suse.com>

> ---
>  drivers/xen/xen-scsiback.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
> index ad4eb10..0695cf8 100644
> --- a/drivers/xen/xen-scsiback.c
> +++ b/drivers/xen/xen-scsiback.c
> @@ -1915,6 +1915,6 @@ module_init(scsiback_init);
>  module_exit(scsiback_exit);
>  
>  MODULE_DESCRIPTION("Xen SCSI backend driver");
> -MODULE_LICENSE("Dual BSD/GPL");
> +MODULE_LICENSE("Dual MIT/GPL");
>  MODULE_ALIAS("xen-backend:vscsi");
>  MODULE_AUTHOR("Juergen Gross <jgross@suse.com>");
> 

