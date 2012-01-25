From: Sven-Haegar Koch <haegar@sdinet.de>
Subject: Re: [v2] Re: [091/129] block: fail SCSI passthrough ioctls on
 partition devices
Date: Wed, 25 Jan 2012 23:51:40 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1201252348520.22090@aurora.sdinet.de>
References: <20120124023932.023409422@clark.kroah.org> <1327423431-13965-1-git-send-email-pbonzini@redhat.com> <20120125223937.GA12516@kroah.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120125223937.GA12516@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 25 Jan 2012, Greg KH wrote:

> On Tue, Jan 24, 2012 at 05:43:50PM +0100, Paolo Bonzini wrote:
> > > You need to return -ENOTTY from scsi_verify_blk_ioctl and -ENOIOCTLCMD from
> > > sd_compat_ioctl, because -ENOIOCTLCMD will not be handled correctly by
> > > block/ioctl.c.  This would break BLKROSET and BLKFLSBUF done by non-root
> > > but with the appropriate capabilities.
> > >
> > > Fixed patch follows.  If you prefer that I send an interdiff, let me know.
> 
> Wait, why do you want the stable trees to diverge from what is in
> Linus's tree with regards to the error codes being returned?
> 
> That doesn't seem safe, or sane.
> 
> So for now, I'm going to follow what is in Linus's tree.  If you
> need/want the error codes to be different, then shouldn't it also be
> done there as well?

May be because the stable trees do not have
07d106d0a33d6063d2061305903deb02489eba20? "vfs: fix up ENOIOCTLCMD error 
handling"?

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
