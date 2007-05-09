From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Wed, 09 May 2007 19:54:32 +0300
Message-ID: <4641FCC8.4040600@panasas.com>
References: <4640C724.8030409@panasas.com>	 <1178654497.3737.81.camel@mulgrave.il.steeleye.com>	 <46417C5A.1090707@panasas.com>	 <200705091052.l49Aqano009015@mbox.iij4u.or.jp>	 <4641D380.8050100@panasas.com> <1178722514.3695.23.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:39986 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756384AbXEIQ4s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2007 12:56:48 -0400
In-Reply-To: <1178722514.3695.23.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

James Bottomley wrote:
> Actually, the first order of business is to use accessors on the command
> pointers in the drivers to free them from the internal layout of the
> structure (and where it is allocated).
> 
Thanks! I totally second that. Let me look into my old patches and come
up with all the needed accessors. I hope 3-5 will be enough.
I will send some suggestions tomorrow.
> 
> No, that's why you do the accessors.  Convert all of the common drivers
> to accessors on the current structure, then throw the switch to convert
> to the new structure (whatever form is finally settled on).  Then any
> unconverted drivers break and people fix the ones they care about.

Last time I was able to compile 97% of drivers and convert by search-and-replace
the rest. Not a huge deal.

> 
> James
> 
> 

