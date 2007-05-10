From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Thu, 10 May 2007 15:53:22 +0900
Message-ID: <20070510155322R.fujita.tomonori@lab.ntt.co.jp>
References: <4641D380.8050100@panasas.com>
	<1178722514.3695.23.camel@mulgrave.il.steeleye.com>
	<4641FCC8.4040600@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:41276 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbXEJGyi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 May 2007 02:54:38 -0400
In-Reply-To: <4641FCC8.4040600@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Wed, 09 May 2007 19:54:32 +0300

> James Bottomley wrote:
> > Actually, the first order of business is to use accessors on the command
> > pointers in the drivers to free them from the internal layout of the
> > structure (and where it is allocated).
> > 
> Thanks! I totally second that. Let me look into my old patches and come
> up with all the needed accessors. I hope 3-5 will be enough.
> I will send some suggestions tomorrow.
> > 
> > No, that's why you do the accessors.  Convert all of the common drivers
> > to accessors on the current structure, then throw the switch to convert
> > to the new structure (whatever form is finally settled on).  Then any
> > unconverted drivers break and people fix the ones they care about.
> 
> Last time I was able to compile 97% of drivers and convert by search-and-replace
> the rest. Not a huge deal.

We need to remove the non-use-sg code in the drivers and convert
them. So it's a bit more complicated than search-and-replace.
