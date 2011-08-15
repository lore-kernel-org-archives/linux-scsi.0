From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH] hpsa: add heartbeat sysfs host attribute
Date: Mon, 15 Aug 2011 09:40:22 -0500
Message-ID: <20110815144022.GR27723@beardog.cce.hp.com>
References: <20110812180314.21808.59261.stgit@beardog.cce.hp.com> <20110813020147.GB15554@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110813020147.GB15554@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 12, 2011 at 07:01:47PM -0700, Greg KH wrote:
> On Fri, Aug 12, 2011 at 01:03:14PM -0500, Stephen M. Cameron wrote:
> > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > 
> > The cciss driver had a CCISS_HEARTBEAT ioctl which
[...]
> >  
> > +  The "heartbeat" read-only attribute returns the value of a heartbeat
> > +  counter register on a Smart Array controller as a 32 bit unsigned
> > +  hexadecimal integer (e.g: "0x12345678").  The value should change
> > +  periodically, not less than once per second.  If this value fails to
> > +  change for a period longer than one second, it means something has
> > +  gone wrong (e.g. Smart Array controller firmware has locked up.)
> > +
> 
> This all belongs in Documentation/ABI/ care to move it there instead?

Sure.

-- steve
