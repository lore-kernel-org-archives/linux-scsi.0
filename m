From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 7/8] be2iscsi: Fix processing cqe for cxn whose endpoint
 is freed
Date: Mon, 2 Jun 2014 13:08:13 -0700
Message-ID: <20140602200813.GA8118@infradead.org>
References: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
 <1399340492-2136-7-git-send-email-jkallickal@emulex.com>
 <536AB13E.6080906@cs.wisc.edu>
 <0eb11761-3b46-44d0-b35a-16d121fe1df4@CMEXHTCAS2.ad.emulex.com>
 <20140602064601.GA6630@infradead.org>
 <1401736926.12939.13.camel@dabdike.int.hansenpartnership.com>
 <20140602193349.GA11555@infradead.org>
 <CA+55aFy+VTFqBi5aQLdB7=04wWmf+gvZzQ1vdrSEuscN7k3xGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58355 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbaFBUIP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 16:08:15 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFy+VTFqBi5aQLdB7=04wWmf+gvZzQ1vdrSEuscN7k3xGw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "hch@infradead.org" <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "MinhDuc.Tran@Emulex.Com" <MinhDuc.Tran@emulex.com>, "jayamohank@gmail.com" <jayamohank@gmail.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Sony.John-N@Emulex.Com" <Sony.John-N@emulex.com>, "Jayamohan.Kallickal@Emulex.Com" <Jayamohan.Kallickal@emulex.com>

On Mon, Jun 02, 2014 at 01:05:38PM -0700, Linus Torvalds wrote:
> I would indeed prefer to avoid rebases, _unless_ the tree is a real
> mess without it.
> 
> Now, what constitues "real mess" can vary. It can be just really ugly
> history, and part of that can be "it doesn't build or work at all
> partway through". If it causes major build or boot failures the code
> is *not* worth merging as-is, because that ends up being really
> painful for bisection etc. But for it to matter for bisection, it has
> to be a _major_ failure that actually matters to real people. So I'm
> not talking about odd "make randomconfig" failures, but painful build
> failures that actually hit reasonable configurations, and boot
> failures that hit relevant hardware configurations.

It's reverting a patch that just doesn't fix a problem fully, so the
prime reviewer and the patch author decided to withdraw it.  It won't
cause any kind of problem during bisection.

