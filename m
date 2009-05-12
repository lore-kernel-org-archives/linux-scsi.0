From: Nick Piggin <npiggin@suse.de>
Subject: Re: Next May 11 : BUG during scsi initialization
Date: Tue, 12 May 2009 07:59:18 +0200
Message-ID: <20090512055918.GF32535@wotan.suse.de>
References: <20090511161442.3e9d9cb9.sfr@canb.auug.org.au> <4A081002.4050802@in.ibm.com> <20090511115233.GB8112@parisc-linux.org> <4A081437.7000409@in.ibm.com> <20090511122135.GC8112@parisc-linux.org> <20090512045716.GC32535@wotan.suse.de> <20090512155613.881fa2ec.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbZELF7T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2009 01:59:19 -0400
Content-Disposition: inline
In-Reply-To: <20090512155613.881fa2ec.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Matthew Wilcox <matthew@wil.cx>, Sachin Sant <sachinp@in.ibm.com>, linux-next@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linuxppc-dev@ozlabs.org, Pekka Enberg <penberg@cs.helsinki.fi>

On Tue, May 12, 2009 at 03:56:13PM +1000, Stephen Rothwell wrote:
> Hi Nick,
> 
> On Tue, 12 May 2009 06:57:16 +0200 Nick Piggin <npiggin@suse.de> wrote:
> >
> > Hmm, I think (hope) your problems were fixed with the recent memory
> > coruption bug fix for SLQB. (if not, let me know)
> > 
> > This one possibly looks like a problem with remote memory allocation
> > or memory hotplug or something like that. I'll do a bit of code
> > review....
> 
> These are -next kernels which include the two fixes you posted recently
> (I am pretty sure).

Yes they should do.


>  I am also getting the network failures that Sachin
> is seeing on several of my machines here.  The previously reported
> problems have gone away.

This one is a SCSI failure... was there also a network one reported?
At any rate, I'm fairly sure this is a problem with SLQB, so it could
easily happen in any early driver setup.
