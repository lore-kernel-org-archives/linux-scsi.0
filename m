From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RESEND][PATCH] scsi: esas2r: fix potential format string flaw
Date: Tue, 17 Dec 2013 12:00:22 -0800
Message-ID: <20131217200022.GD28274@kroah.com>
References: <20131217182733.GA16202@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131217182733.GA16202@www.outflux.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 17, 2013 at 10:27:33AM -0800, Kees Cook wrote:
> This makes sure format strings cannot leak into the printk call via the
> constructed buffer.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/scsi/esas2r/esas2r_log.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Why is this patch "To:" me?  I'm not the author of this driver, or the
maintainer of it or the subsystem, and there's not much, if anything I
can do with it...

confused,

greg k-h
