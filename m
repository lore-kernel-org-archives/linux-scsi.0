From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux tape drivers
Date: Wed, 4 Apr 2007 14:43:23 -0700
Message-ID: <20070404144323.5c87086f.akpm@linux-foundation.org>
References: <200704031508.37222.kern@sibbald.com>
	<150283e90704041222v1d8554b6lcb5a6771d4a031b4@mail.gmail.com>
	<20070404133919.ebcd0ddc.akpm@linux-foundation.org>
	<200704042331.06105.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57353 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbXDDVoR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Apr 2007 17:44:17 -0400
In-Reply-To: <200704042331.06105.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Willem Riede <wrlk@riede.org>, Kern Sibbald <kern@sibbald.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>

On Wed, 4 Apr 2007 23:31:06 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Wednesday 04 April 2007, Andrew Morton wrote:
> > On Wed, 4 Apr 2007 12:22:35 -0700
> > "Willem Riede" <wrlk@riede.org> wrote:
> > 
> > > On 4/4/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > On Wed, 4 Apr 2007 16:26:14 +0200 Kern Sibbald <kern@sibbald.com> wrote:
> > > >
> > > > >  I'm all in favor of deprecating ide-tape if ide-scsi is a viable alternative,
> > > >
> > > > ow.  ide-scsi is in very bad shape and nobody is maintaining it or fixing
> > > > bugs in it or anything.  The only reason we retain ide-scsi at all is, err,
> 
> I haven't heard about any major bugs besides well known module unload problem.
> 
> What have I missed?

oop, caught making unsubstantiatable assertions.

I've seen an ongoing dribble of doesn't-work and it-crashes reports and I
simply have not made any record of them, because it's ide-scsi and I don't
expect there's anything we can do about them :(

Often these reports are from people who are writing CDROMs and the usual
response is "use cdrecord dev=/dev/hdc".

I think Alan and Jens might have some thoughts on the ide-scsi status?
