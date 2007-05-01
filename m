From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 4/4] bidi support: bidirectional request
Date: Wed, 02 May 2007 04:01:21 +0900
Message-ID: <20070502040121T.fujita.tomonori@lab.ntt.co.jp>
References: <20070430145105.GO21015@kernel.dk>
	<4637856F.5090404@panasas.com>
	<20070501185718.GE4653@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:43994 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161781AbXEATCA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 May 2007 15:02:00 -0400
In-Reply-To: <20070501185718.GE4653@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: bharrosh@panasas.com, James.Bottomley@SteelEye.com, hch@infradead.org, dougg@torque.net, bhalevy@panasas.com, tomof@acm.org, akpm@osdl.org, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 4/4] bidi support: bidirectional request
Date: Tue, 1 May 2007 20:57:20 +0200

> On Tue, May 01 2007, Boaz Harrosh wrote:
> > Please consider the attached proposal. It is a complete block-level bidi
> > implementation that is, I hope, a middle ground which will keep everyone
> > happy (including Christoph). It is both quite small and not invasive,
> > yet has a full bidi API that is easy to use and maintain.
> 
> This isn't much of an improvement imo, if any at all. Why didn't you do
> the ->next_rq approach I suggested? Your patch still makes struct
> request considerably fatter (30% here, from 280 to 368 bytes on x86-64
> from a quick look) for something that will have relatively few uses. And
> it still has its paws all over the block layer code.
> 
> Please just implement the 2nd data phase as a linked request off the
> first one. I think that approach is both much cleaner from a design
> perspective, and also much leaner and has zero (well almost, it costs a
> pointer) impact on the regular read-write paths.

I will send a next_rq patch shortly.
