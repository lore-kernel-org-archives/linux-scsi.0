From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 4 Mar 2008 20:34:30 +0100
Message-ID: <20080304193430.GX6704@kernel.dk>
References: <20080304093536.GH6704@kernel.dk> <1204634238.5997.5.camel@homer.simson.net> <47CD4355.4050401@gmail.com> <20080304223006A.tomof@acm.org> <47CD53BA.5040908@gmail.com> <47CD7611.2030606@gmail.com> <47CD7C05.1080707@gmail.com> <1204656328.6598.1.camel@homer.simson.net> <20080304192551.GU6704@kernel.dk> <1204659196.6284.7.camel@homer.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:24396 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932324AbYCDTef (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 14:34:35 -0500
Content-Disposition: inline
In-Reply-To: <1204659196.6284.7.camel@homer.simson.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>
Cc: Tejun Heo <htejun@gmail.com>, FUJITA Tomonori <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

On Tue, Mar 04 2008, Mike Galbraith wrote:
> 
> On Tue, 2008-03-04 at 20:25 +0100, Jens Axboe wrote:
> > On Tue, Mar 04 2008, Mike Galbraith wrote:
> > > 
> > > On Wed, 2008-03-05 at 01:42 +0900, Tejun Heo wrote:
> > > 
> > > > The following patch gets the writing going.
> > > 
> > > Bingo.
> > 
> > Pretty please test this on top of current -git?
> 
> ?  That's the patch I just tested, and the tree.  Oh.. 976dde0..87baa2b
> just a sec....

Yeah it is, mid-air collision of emails. So just disregard this one!

-- 
Jens Axboe

