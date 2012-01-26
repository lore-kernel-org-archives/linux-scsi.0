From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 1/2] Staging: hv: Applied all the patches already in the
 staging queue
Date: Thu, 26 Jan 2012 09:37:51 -0800
Message-ID: <20120126173751.GA14400@suse.de>
References: <1327599460-12593-1-git-send-email-kys@microsoft.com>
 <1327599515-12679-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1327599515-12679-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 26, 2012 at 09:38:34AM -0800, K. Y. Srinivasan wrote:
> This patch gets the storage driver to the same level as in the staging tree.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/staging/hv/storvsc_drv.c | 1301 ++++++++++++++++++-------------------
>  1 files changed, 633 insertions(+), 668 deletions(-)

What?  That changelog comment makes no sense at all, as you are patching
the staging version of the driver.  This isn't an acceptable patch at
all.

Yes, I have pending patches for this driver in my "to-apply" queue, but
that is for 3.4, not now.

So, how about I just apply those patches, and then apply a patch that
moves it out of staging into drivers/scsi/, and queue all of those up
for 3.4.

James, any objection to that?

thanks,

greg k-h
