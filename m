From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] Drivers: scsi: storvsc: Set the scsi result
 correctly when SRB status is INVALID
Date: Fri, 16 Mar 2012 13:36:42 -0700
Message-ID: <20120316203642.GA14802@kroah.com>
References: <1331929448-6838-1-git-send-email-kys@microsoft.com>
 <1331929472-6877-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1331929472-6877-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 16, 2012 at 01:24:31PM -0700, K. Y. Srinivasan wrote:
> Currently Windows hosts only support a subset of scsi commands and for commands
> that are not supported, the host returns a generic SRB failure status.
> However, they have agreed to change the return value to indicate that
> the command is not supported. In preparation for that, handle the 
> SRB_STATUS_INVALID_REQUEST return value correctly.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |    8 ++++++++

I need an ack from the scsi maintainer before I can accept this patch.

James?
