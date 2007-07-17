From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 12:48:10 -0700
Message-ID: <20070717124810.cdf54572.akpm@linux-foundation.org>
References: <20070717065940.GZ5195@kernel.dk>
	<20070717160816K.fujita.tomonori@lab.ntt.co.jp>
	<20070717071045.GD5195@kernel.dk>
	<20070717190705T.fujita.tomonori@lab.ntt.co.jp>
	<20070717101928.GK5195@kernel.dk>
	<1184698434.3378.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39778 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757527AbXGQTst (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2007 15:48:49 -0400
In-Reply-To: <1184698434.3378.15.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 17 Jul 2007 13:53:54 -0500 James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Tue, 2007-07-17 at 12:19 +0200, Jens Axboe wrote:
> > > > Since Linus is happily snoring by now, could you test and see if the
> > > > tree works for you?
> > > 
> > > It works for me. I'll submit some minor patches against your bsg
> > > branch to scsi-ml. Can you push them together?
> > 
> > Certainly, I'll pull them into the bsg branch.
> 
> While you're at it, here's a patch to separate BSG and SCSI again (so
> SCSI can be built modular).  The way I did it was simply to move the
> SCSI specific logic into SCSI.  When you come up with a generic way to
> register the bsg requiring drivers, then we can move it out again.

I note that block/scsi_ioctl.c is geting compiled with CONFIG_SCSI=n. 
Seems odd.

(Actually, it's failing to compile (in the middle of the bsg series) so I need
to fix it by hand somehow to continue this bisect)
