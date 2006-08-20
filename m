From: Andrew Morton <akpm@osdl.org>
Subject: Re: ybin on powerpc
Date: Sat, 19 Aug 2006 20:12:15 -0700
Message-ID: <20060819201215.fb0bc2d2.akpm@osdl.org>
References: <20060819111919.a60dca49.akpm@osdl.org>
	<1156024644.5803.73.camel@localhost.localdomain>
	<20060819182818.bf3ff5bc.akpm@osdl.org>
	<20060820015629.GU4340@parisc-linux.org>
	<20060819192811.f7113147.akpm@osdl.org>
	<20060820030559.GV4340@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:59600 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751471AbWHTDMZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 23:12:25 -0400
In-Reply-To: <20060820030559.GV4340@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Sat, 19 Aug 2006 21:05:59 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Sat, Aug 19, 2006 at 07:28:11PM -0700, Andrew Morton wrote:
> > On Sat, 19 Aug 2006 19:56:30 -0600
> > Matthew Wilcox <matthew@wil.cx> wrote:
> > > BTW, the SCSI specs changed the name from CD-ROM to CD/DVD.  I'd like to
> > > reflect that change in /proc/scsi/scsi; is there any userspace currently
> > > relying on that spelling?
> > 
> > I think that's basically unknowable.  How does one grep all userspace?
> 
> apt-cache search?  ;-)

Well yeah.  Smiley noted, but let us remember that "userspace" includes
non-published and non-open-source code.

> > The only practical way to find out is to change it, see what breaks and
> > hope that people report it in time.  That's a terribly blunt weapon.
> > 
> > It's better to get the interfaces right first time ;)
> 
> Yeah; kind of hard to do when the SCSI committee changes the spec on you.

I think people will continue to understand what we mean.
