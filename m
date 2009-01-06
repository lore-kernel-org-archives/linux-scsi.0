From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 07/18] osd_ktests: Add basic OSD tests
Date: Wed, 7 Jan 2009 01:58:30 +0900
Message-ID: <20090107015837W.fujita.tomonori@lab.ntt.co.jp>
References: <49637117.50108@panasas.com>
	<20090107001206N.fujita.tomonori@lab.ntt.co.jp>
	<49637D70.1060709@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:51609 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbZAFQ6u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2009 11:58:50 -0500
In-Reply-To: <49637D70.1060709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, osd-dev@open-osd.org, akpm@linux-foundation.org

On Tue, 06 Jan 2009 17:49:04 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> FUJITA Tomonori wrote:
> > On Tue, 06 Jan 2009 16:56:23 +0200
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >> FUJITA Tomonori wrote:
> >>> On Tue,  6 Jan 2009 16:17:16 +0200
> >>> Why do we need in-kernel test suite?
> >> It must be in kernel, because it tests the in-kernel library.
> >> However it could be in it's own Module, which makes it more
> >> complicated, but doable.
> > 
> > Why do we need the code to tests the in-kernel library?
> > 
> > I expect that you guys have tested the osd in-kernel library heavily
> > and will. I don't think people want to do the same. Then why do we
> > need to have the test suite in mainline?
> > 
> 
> one - There are things that can regress. Lots of stuff in current
> kernel are only used by OSD, like bidi and varlen. all the way down
> to LLDs. So this should be a regression test for future kernels.

SMP has been using BIDI support. FC will use it too soon, I guess.

If you want to test bidi and varlen, you can just send SCSI commands
via bsg. That's what I did. I don't see how it can be a reason why we
need the in-kernel test suite.


> two - To test compatibility, some thing is broken, the test can help
> pinpoint the problems. So it's a debugging tool.
> 
> Sure, the lib itself is heavily tested but this is to test the
> round trip.

I think that it's fine if people want a debugging tool. I've not seen
any developer who say that.

IMHO, it's better to have only useful debugging stuff in mainline for
many people like scsi_debug.
