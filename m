From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Tue, 7 Aug 2007 10:51:44 -0700
Message-ID: <20070807105144.0ba67d81.akpm@linux-foundation.org>
References: <1186248703.3439.20.camel@localhost.localdomain>
	<alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>
	<1186458941.6637.44.camel@localhost.localdomain>
	<20070807001429.f8cb3b22.akpm@linux-foundation.org>
	<1186496712.3414.17.camel@localhost.localdomain>
	<46B88B91.4050703@garzik.org>
	<1186501124.3414.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45241 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760895AbXHGRwD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 13:52:03 -0400
In-Reply-To: <1186501124.3414.32.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, 07 Aug 2007 10:38:44 -0500 James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Tue, 2007-08-07 at 11:11 -0400, Jeff Garzik wrote:
> > James Bottomley wrote:
> > > The initial bsg submit went via the block git tree ... which I believe
> > > you have in -mm.  We only started taking the updates via the scsi tree
> > 
> > Seven hours before you posted this, in 
> > <20070807001429.f8cb3b22.akpm@linux-foundation.org>, Andrew already 
> > noted it was not in -mm.
> > 
> > A trivial examination of the broken-out mm patches backs up the absence 
> >   of Jens' block tree, too.
> > 
> > So let's put this myth / bad assumption to rest, shall we?
> 
> Sorry ... I just assumed from the fact that it had been in the block git
> tree for six months that it was also in -mm.

bsg was never in the #for-akpm branch of git-block.  So I assume that
Jens had it in some other branch and for some reason never pulled it
across into #for-akpm.

It was most reasonable of you to expect that bsg had received a decent
run in -mm.
