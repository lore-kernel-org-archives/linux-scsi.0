From: Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] [29/82] x86_64: Rename IOMMU option, fix help and mark option embedded.
Date: Sun, 25 Jun 2006 18:21:15 -0400
Message-ID: <20060625222115.GA17213@devserv.devel.redhat.com>
References: <449C852C.mailCZT11F9YB@suse.de> <200606251722.23294.ak@suse.de> <20060625190054.GA6570@devserv.devel.redhat.com> <200606252132.41121.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:28381 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932398AbWFYWVd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jun 2006 18:21:33 -0400
Content-Disposition: inline
In-Reply-To: <200606252132.41121.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@redhat.com>, torvalds@osdl.org, discuss@x86-64.org, akpm@osdl.org, markh@osdl.org, linux-scsi@vger.kernel.org, axboe@suse.de

On Sun, Jun 25, 2006 at 09:32:41PM +0200, Andi Kleen wrote:
> > From a tiny 16MB DMA pool that can't sustain the required load ? Or has that
> > bit changed.
> 
> It should be ok because it blocks. It will be slow, but what else do you expect
> from broken hardware like this? 

Sustained 80Mbyte/second I/O rates. At least thats what it gets in other OS
products. This is one of the reasons (broadcomm 4400 was another) that a 30
or 31 bit DMA zone not a 32bit one was called for, which also didn't happen
it seems.

The ifdef approach isnt perfect but it essentially means you get good
performance on x86-32 and only x86-64 has problems which seems fine to me,
because its an old card.

Alan

