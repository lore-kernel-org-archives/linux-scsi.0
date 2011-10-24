From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in
 pmcraid_chr_ioctl()
Date: Mon, 24 Oct 2011 16:17:23 -0700
Message-ID: <1319498243.2094.9.camel@Joe-Laptop>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net>
	 <1319496149.2094.3.camel@Joe-Laptop>
	 <alpine.LNX.2.00.1110250047430.19795@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1110250047430.19795@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-10-25 at 00:51 +0200, Jesper Juhl wrote:
> On Mon, 24 Oct 2011, Joe Perches wrote:
> > On Tue, 2011-10-25 at 00:38 +0200, Jesper Juhl wrote:
> > > The first argument to kmalloc() is the size, the second is
> > > flags. pmcraid_chr_ioctl() gets this wrong and swaps the
> > > arguments. This patch corrects the mistake.
[]
> > James seems to be uninterested in picking up
> > obvious and trivially correct patches.
> I've been getting that impression as well..
> For example: 
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next-history.git;a=commitdiff;h=2abe1b25e56b7c8e65f101fb22282dafeb5ec4ef 
> which I've been sumbitting numerous times over a long period of time 
> (these days akpm has picked it up and sends it on repeatedly, so I don't 
> really bother myself any more)... 
> > >From a year ago...
> > https://lkml.org/lkml/2010/10/31/123
> Ok, so you obviously got there first

That doesn't matter at all to me.

What matters is getting the defects fixed
and not dropping patches on the floor.

Maybe that means there should be a different
or an additional scsi maintainer.
