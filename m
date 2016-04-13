From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/4] Decouple X86_32 dependency from the ISA Kconfig
 option
Date: Wed, 13 Apr 2016 08:18:26 -0700
Message-ID: <20160413151826.GA13959@kroah.com>
References: <cover.1460379702.git.vilhelm.gray@gmail.com>
 <20160413072602.GA7629@gmail.com>
 <20160413121515.GA23870@sophia>
 <20160413143838.GD5867@gmail.com>
 <20160413144842.GA26005@sophia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160413144842.GA26005@sophia>
Sender: linux-kernel-owner@vger.kernel.org
To: William Breathitt Gray <vilhelm.gray@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 13, 2016 at 10:48:42AM -0400, William Breathitt Gray wrote:
> On Wed, Apr 13, 2016 at 04:38:38PM +0200, Ingo Molnar wrote:
> >Ah, ok, so it's for enabling real hardware, not just a cleanup, right? You might 
> >want to put that info into the boilerplate mail or so.
> >
> >I'm perfectly fine with all the patches that touch x86 code:
> >
> >  Acked-by: Ingo Molnar <mingo@kernel.org>
> >
> >I suppose you'd like to have these in the driver tree, all in one place?
> >
> >Thanks,
> >
> >	Ingo
> 
> Ah yes, in retrospect I should have made it clear that this was for
> supporting hardware rather than simply code cleanup. That was an
> oversight on my part not to have made it more explicit.
> 
> Introducing everything to the driver tree would be most convenient, thus
> allowing me to quickly release my subsequent patches which will be
> rebased on top of these.

Ok, I can take these.

thanks,

greg k-h
