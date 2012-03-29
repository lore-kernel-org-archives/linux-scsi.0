From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Properly handle errors from
 the host
Date: Thu, 29 Mar 2012 16:51:11 -0700
Message-ID: <20120329235111.GA19924@kroah.com>
References: <1333065283-30484-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44668 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933200Ab2C2XvQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Mar 2012 19:51:16 -0400
Received: by pbcun15 with SMTP id un15so814696pbc.19
        for <linux-scsi@vger.kernel.org>; Thu, 29 Mar 2012 16:51:15 -0700 (PDT)
In-Reply-To: <1333065283-30484-1-git-send-email-kys@microsoft.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org

On Thu, Mar 29, 2012 at 04:54:43PM -0700, K. Y. Srinivasan wrote:
> If the host returns error for pass through commands, deal with
> appropriately. I would like to thank James for patiently helping
> me with this patch.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |   20 ++++++++++++++++----
>  1 files changed, 16 insertions(+), 4 deletions(-)

As this driver is now in Linus's tree, and drivers/scsi/ is James's
area, he is the one to take them, not me.

thanks,

greg k-h
