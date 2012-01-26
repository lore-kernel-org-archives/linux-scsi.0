From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH stable 3/4] block: fail SCSI passthrough ioctls on
 partition devices
Date: Thu, 26 Jan 2012 10:28:29 -0800
Message-ID: <20120126182829.GB22334@kroah.com>
References: <1326772723.2819.167.camel@deadeye>
 <1326773222.2819.172.camel@deadeye>
 <4F1545A4.3000809@redhat.com>
 <1326862077.2819.210.camel@deadeye>
 <4F168A49.8000606@redhat.com>
 <1326902676.3271.10.camel@deadeye>
 <4F1EAA6A.6020207@redhat.com>
 <20120126001926.GA1058@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120126001926.GA1058@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 25, 2012 at 04:19:26PM -0800, Greg KH wrote:
> On Tue, Jan 24, 2012 at 01:56:10PM +0100, Paolo Bonzini wrote:
> > On 01/18/2012 05:04 PM, Ben Hutchings wrote:
> > >>  There is harm.  You'll be blacklisting also the standard block device
> > >>  ioctls, and those won't work on 32-on-64 anymore.  A system with 32-bit
> > >>  userland will likely not boot anymore.
> > >
> > >It does (yes, I tested that myself now).  The standard block device
> > >ioctls are handled without calling the driver's compat_ioctl.
> > 
> > What about the non-compat path when done by non-root?
> > 
> > * Does BLKROSET still return EACCES when run by non-root and without
> > CAP_SYS_ADMIN?  I suspect your patch is changing it to EINVAL.
> > 
> > * Does BLKFLSBUF work when run by non-root but with CAP_SYS_ADMIN?
> 
> I'm confused here as well.
> 
> Can someone please send me the proper patch that I need to apply to
> resolve this issue on the 2.6.32.y kernel?

Ok, I think I've queued up the correct ones, please let me know if I
messed something up.

thanks,

greg k-h
