From: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 3/5] drivers/scsi : Correct the size argument to kmalloc
Date: Wed, 30 Dec 2009 12:29:20 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0912301228540.23134@ask.diku.dk>
References: <Pine.LNX.4.64.0912292015420.4001@ask.diku.dk>
 <200912292102.43373.eike-kernel@sf-tec.de>  <Pine.LNX.4.64.0912292103180.4001@ask.diku.dk>
 <1262121796.1888.190.camel@Joe-Laptop.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:45382 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbZL3L3X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Dec 2009 06:29:23 -0500
In-Reply-To: <1262121796.1888.190.camel@Joe-Laptop.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Tue, 29 Dec 2009, Joe Perches wrote:

> On Tue, 2009-12-29 at 21:04 +0100, Julia Lawall wrote:
> > On Tue, 29 Dec 2009, Rolf Eike Beer wrote:
> > > Julia Lawall wrote:
> > > > From: Julia Lawall <julia@diku.dk>
> > > > In each case, the destination of the allocation has type struct **, so the
> > > > elements of the array should have pointer type, not structure type.
> > > Maybe they should even by kcalloc'ed?
> > I thought about that, but in response to another patch someone seemed to 
> > think kcalloc was not very useful.  But I can certainly change it in this 
> > case.
> 
> I think kcalloc is useful and should be used when the
> allocated array of elements needs to be zeroed.
> 
> It appears the uses in 1/5 and 3/5 don't need it but
> maybe patch 2/5 and 4/5 should use kcalloc.

I will look into changing them too.

julia
