From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/1] Staging: hv: storvsc: Move the storage driver out of
 the staging area
Date: Thu, 9 Feb 2012 12:04:04 -0800
Message-ID: <20120209200404.GA8816@kroah.com>
References: <1328817851-13435-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1328817851-13435-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 09, 2012 at 12:04:11PM -0800, K. Y. Srinivasan wrote:
> The storage driver (storvsc_drv.c) handles all block storage devices
> assigned to Linux guests hosted on Hyper-V. This driver has been in the
> staging tree for a while and this patch moves it out of the staging area.
> As per Greg's recommendation, this patch makes no changes to the staging/hv
> directory. Once the driver moves out of staging, we will cleanup the
> staging/hv directory.
> 
> James was willing to apply this patch during the 3.3-rc phase and a decision
> was taken to defer this to 3.4 since Greg had queued up a bunch of storvsc
> patches for 3.4. Now that Greg has applied all of the pending storvsc patches,
> I am re-sending this patch to move this driver out of staging.
> 
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/Kconfig       |    7 +
>  drivers/scsi/Makefile      |    3 +
>  drivers/scsi/storvsc_drv.c | 1548 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1558 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/scsi/storvsc_drv.c

James, any objection to me applying this to the staging-next tree, and
at the same time, deleting this version of the driver from the
drivers/staging/hv/ directory?

thanks,

greg k-h
