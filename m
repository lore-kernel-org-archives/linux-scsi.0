From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RESEND][PATCH] scsi: esas2r: fix potential format string flaw
Date: Tue, 17 Dec 2013 13:54:36 -0800
Message-ID: <20131217215436.GA19898@kroah.com>
References: <20131217182733.GA16202@www.outflux.net>
 <20131217200022.GD28274@kroah.com>
 <CAGXu5j+wwkiz9=s3DBnmDXmtR_YdtqvXOe5PJsNbRcs_UCGajA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5j+wwkiz9=s3DBnmDXmtR_YdtqvXOe5PJsNbRcs_UCGajA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 17, 2013 at 01:17:51PM -0800, Kees Cook wrote:
> On Tue, Dec 17, 2013 at 12:00 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Tue, Dec 17, 2013 at 10:27:33AM -0800, Kees Cook wrote:
> >> This makes sure format strings cannot leak into the printk call via the
> >> constructed buffer.
> >>
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >> ---
> >>  drivers/scsi/esas2r/esas2r_log.c |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Why is this patch "To:" me?  I'm not the author of this driver, or the
> > maintainer of it or the subsystem, and there's not much, if anything I
> > can do with it...
> 
> I've resent this before, and since it lived in "drivers", I figured
> you would be the next up the chain to take it (since it's been
> ignored).

Heh, while I do seem to maintain a ton of the drivers/ tree, I don't
take everything there.  This needs to go through James's tree, he can
handle it :)

thanks,

greg k-h
