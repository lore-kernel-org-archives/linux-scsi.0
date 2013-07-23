From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mvsas: fix unaligned-access kernel panic under heavy
 disk testing
Date: Tue, 23 Jul 2013 15:55:57 -0700
Message-ID: <1374620157.2290.54.camel@dabdike>
References: <201307232053.r6NKrkOh032171@farm-0012.internal.tilera.com>
	  <1374613204.2290.49.camel@dabdike> <51EEF2DA.3070903@tilera.com>
	 <1374618791.2290.53.camel@dabdike> <51EF0643.5030507@tilera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51EF0643.5030507@tilera.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Jianpeng Ma <majianpeng@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Xi Wang <xi.wang@gmail.com>, Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-07-23 at 18:40 -0400, Chris Metcalf wrote:
> On 7/23/2013 6:33 PM, James Bottomley wrote:
> > On Tue, 2013-07-23 at 17:17 -0400, Chris Metcalf wrote:
> >> On 7/23/2013 5:00 PM, James Bottomley wrote:
> >>> On Tue, 2013-07-23 at 16:50 -0400, Chris Metcalf wrote:
> >>>>> The slot->response value may not be aligned, so should be read
> >>>>> using the appropriate kernel "unaligned" accessor.
> >>> Hm, institutional memory re-presenting the wrong patch?  However, I am
> >>> reminded to push the right one in spite of no ack from marvell.
> >> You may be right; the original author of that patch is not me, but someone else here at Tilera.
> >>
> >> That said, the version I pushed is effectively the version we have in the tip of our tree, so if we've ended up carrying the wrong patch, that's bad!  Let me know what the right patch is that you have - thanks.
> > This is what I have.
> 
> Thanks, I've merged the optimization back into our tree :-)

Well it was originally a compile fix and a fast path optimisation.  I
notice the compile fix made it back.

James
