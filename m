From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: ybin on powerpc
Date: Sat, 19 Aug 2006 21:05:59 -0600
Message-ID: <20060820030559.GV4340@parisc-linux.org>
References: <20060819111919.a60dca49.akpm@osdl.org> <1156024644.5803.73.camel@localhost.localdomain> <20060819182818.bf3ff5bc.akpm@osdl.org> <20060820015629.GU4340@parisc-linux.org> <20060819192811.f7113147.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:7813 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750896AbWHTDGA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 23:06:00 -0400
Content-Disposition: inline
In-Reply-To: <20060819192811.f7113147.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Sat, Aug 19, 2006 at 07:28:11PM -0700, Andrew Morton wrote:
> On Sat, 19 Aug 2006 19:56:30 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
> > BTW, the SCSI specs changed the name from CD-ROM to CD/DVD.  I'd like to
> > reflect that change in /proc/scsi/scsi; is there any userspace currently
> > relying on that spelling?
> 
> I think that's basically unknowable.  How does one grep all userspace?

apt-cache search?  ;-)

> The only practical way to find out is to change it, see what breaks and
> hope that people report it in time.  That's a terribly blunt weapon.
> 
> It's better to get the interfaces right first time ;)

Yeah; kind of hard to do when the SCSI committee changes the spec on you.

