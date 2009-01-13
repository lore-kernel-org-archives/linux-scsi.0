From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 7/9] exofs: mkexofs
Date: Tue, 13 Jan 2009 14:03:28 +0000
Message-ID: <20090113140328.3aab5a35@lxorguk.ukuu.org.uk>
References: <4947BFAA.4030208@panasas.com>
	<4947CA5C.50104@panasas.com>
	<20081229121423.efde9d06.akpm@linux-foundation.org>
	<495B8D90.1090004@panasas.com>
	<1230739053.3408.74.camel@localhost.localdomain>
	<4960D3CA.2000202@panasas.com>
	<1231783926.3256.29.camel@localhost.localdomain>
	<496B989F.7050907@garzik.org>
	<1231790190.15161.29.camel@localhost.localdomain>
	<496BA671.3070900@garzik.org>
	<1231802758.27151.18.camel@localhost.localdomain>
	<496C9ABE.8060300@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <496C9ABE.8060300@garzik.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Matthew Wilcox <matthew@wil.cx>, Benny Halevy <bhalevy@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Avishay Traeger <avishay@gmail.com>, open-osd development <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> It seems unlikely drive manufacturers would get excited about a 
> sub-optimal solution that does not even approach using the full 
> potential of the product.

You forgot the more important people

Mr Customer, would you like your data centre to use a new magic OSD fs or
the existing one you trust.

Now in my experience that is a *dumb* question because the answer is
obvious...

> Plus, given the existence of an OSD-specific filesystem (exofs, at the 
> very least), it seems unlikely that end users who own OSDs would choose 
> the sub-optimal solution when an OSD-specific filesystem exists.

Actually until you can show zillions of users stably using them the
people with the money won't buy them in the first place 8)

> > ready for the consumer market until 2011.  That's not really going to
> > convince the disk vendors that OSD based devices should be marketed
> > today.
> 
> And you have a similar sales job and lag time, when hacking -- read 
> destabilizing -- a filesystem to work with OSDs as well as sector-based 
> devices.

2011 sounds optimistic for major OSD adoption in any space except for
flash storage where OSD type knowledge means you can do much better jobs
on erase management.

