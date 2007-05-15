From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/19] clean ups on the drivers
Date: Tue, 15 May 2007 12:57:48 +0100
Message-ID: <20070515115748.GA12461@infradead.org>
References: <20070512190534B.fujita.tomonori@lab.ntt.co.jp> <20070512153023.GA8088@infradead.org> <200705141440.l4EEe3dB004194@mbox.iij4u.or.jp> <4648829A.10602@s5r6.in-berlin.de> <20070515090116.GA9297@infradead.org> <1179230056.3685.2.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38895 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbXEOL5y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2007 07:57:54 -0400
Content-Disposition: inline
In-Reply-To: <1179230056.3685.2.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Tue, May 15, 2007 at 06:54:16AM -0500, James Bottomley wrote:
> Er ... I really hope not ... that's exactly how the parisc iommu
> platform code works ... and why I designed the generic dma mapping this
> way.  The key thing parisc needed was the ability to walk up different
> busses until it found the iommu (for example the pci bus -> dino -> GSC
> -> IOMMU) which it does by traversing the dev->parent; However, I didn't
> mandate working this way for other architectures.

Well, the NACK was not for the implementation details but rather the
exported and documented interface.  IIRC the rationale was that Dave wants
to keep the sparc implementation super-optimized and avoid indirection.

If it was up to me I'd have something like the parisc implementation in
generic code.
