From: Christoph Hellwig <hch@infradead.org>
Subject: Re: advansys regions [Re: 2.4 vs 2.6 versions of include/linux/ioport.h]
Date: Thu, 7 Aug 2003 08:36:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030807083626.B766@infradead.org>
References: <200308051041.08078.gene.heskett@verizon.net> <20030805075758.31f51879.rddunlap@osdl.org> <200308052050.07841.gene.heskett@verizon.net> <20030806104041.4a09f4f0.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:2310 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S275200AbTHGHg3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 03:36:29 -0400
Content-Disposition: inline
In-Reply-To: <20030806104041.4a09f4f0.rddunlap@osdl.org>; from rddunlap@osdl.org on Wed, Aug 06, 2003 at 10:40:41AM -0700
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: gene.heskett@verizon.net, linux-scsi@vger.kernel.org

On Wed, Aug 06, 2003 at 10:40:41AM -0700, Randy.Dunlap wrote:
> I'm not terribly interested in spending much time on this driver,
> so the simplest thing to do IMO is to emulate check_region() with
> pairs of request_region() and release_region() calls.  Yes, this
> is still racy, just like check_region() was.  Is that a problem
> in your machine environment?
> 
> Below is a patch that uses request_region/release_region pairs
> instead of check_region().  Does it work for you?

What the heck?  Just continue using check_region if you don't want
to spend the time fixing it.  At least we get a warning in that
case.

