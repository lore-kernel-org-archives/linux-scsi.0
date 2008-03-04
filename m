From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 04 Mar 2008 20:33:16 +0100
Message-ID: <1204659196.6284.7.camel@homer.simson.net>
References: <20080304093536.GH6704@kernel.dk>
	 <1204634238.5997.5.camel@homer.simson.net> <47CD4355.4050401@gmail.com>
	 <20080304223006A.tomof@acm.org> <47CD53BA.5040908@gmail.com>
	 <47CD7611.2030606@gmail.com> <47CD7C05.1080707@gmail.com>
	 <1204656328.6598.1.camel@homer.simson.net>
	 <20080304192551.GU6704@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080304192551.GU6704@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <htejun@gmail.com>, FUJITA Tomonori <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org


On Tue, 2008-03-04 at 20:25 +0100, Jens Axboe wrote:
> On Tue, Mar 04 2008, Mike Galbraith wrote:
> > 
> > On Wed, 2008-03-05 at 01:42 +0900, Tejun Heo wrote:
> > 
> > > The following patch gets the writing going.
> > 
> > Bingo.
> 
> Pretty please test this on top of current -git?

?  That's the patch I just tested, and the tree.  Oh.. 976dde0..87baa2b
just a sec....

	-Mike

