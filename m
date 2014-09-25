From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] Drivers: scsi: storvsc: Fix issues with
 hot-add/remove of LUNs
Date: Thu, 25 Sep 2014 06:47:26 -0700
Message-ID: <20140925134726.GA26946@infradead.org>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1408244954-27417-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: hare@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

So can anywayone give me a review for those two patches?  

On Sat, Aug 16, 2014 at 08:09:14PM -0700, K. Y. Srinivasan wrote:
> This patch-set addresses issues with LUN hot-add and remove. When the host
> notifies the guest that a scan is needed, scan the host. Also, prior to
> discovering new devices that may have been added, ensure we handle the
> LUN remove case first.
> 
> K. Y. Srinivasan (2):
>   Drivers: scsi: storvsc: In responce to a scan event, scan the host
>   Drivers: scsi: storvsc: Force discovery of LUNs that may have been
>     removed.
> 
>  drivers/scsi/storvsc_drv.c |   43 ++++++++++++++++++++++++++++++++-----------
>  1 files changed, 32 insertions(+), 11 deletions(-)
> 
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
