From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 4 Mar 2008 20:28:37 +0100
Message-ID: <20080304192837.GV6704@kernel.dk>
References: <1204634619.17258.0.camel@homer.simson.net> <1204635515.17258.12.camel@homer.simson.net> <20080304130307.GN6704@kernel.dk> <1204640722.5783.10.camel@homer.simson.net> <20080304181736.GP6704@kernel.dk> <1204655711.19496.10.camel@homer.simson.net> <20080304184534.GR6704@kernel.dk> <1204656555.6598.4.camel@homer.simson.net> <20080304185420.GT6704@kernel.dk> <1204658770.6284.2.camel@homer.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:27133 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761245AbYCDT2n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 14:28:43 -0500
Content-Disposition: inline
In-Reply-To: <1204658770.6284.2.camel@homer.simson.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, htejun@gmail.com, tomof@acm.org, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

On Tue, Mar 04 2008, Mike Galbraith wrote:
> 
> On Tue, 2008-03-04 at 19:54 +0100, Jens Axboe wrote:
> > On Tue, Mar 04 2008, Mike Galbraith wrote:
> > > 
> > > On Tue, 2008-03-04 at 19:45 +0100, Jens Axboe wrote:
> > > 
> > > > > It says cc66b4512cae8df4ed1635483210aabf7690ec27... kewpie doll?
> > > > 
> > > > That looks right, then perhaps there's still an issue there :/
> > > > Logs?
> > > 
> > > Tejuns patchlet (below) fixed it here.
> > 
> > OK, can you try changing that to
> > 
> >         good_bytes = scsi_bufflen(cmd) + cmd->request->extra_len;
> > 
> > and retest?
> 
> Yup, disk #42 is happily burning away.

Super, patch heading to Linus now. Thanks for all your testing, Mike!

-- 
Jens Axboe

