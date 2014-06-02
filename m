From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 7/8] be2iscsi: Fix processing cqe for cxn whose endpoint
 is freed
Date: Mon, 2 Jun 2014 13:32:43 -0700
Message-ID: <20140602203243.GA11802@infradead.org>
References: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
 <1399340492-2136-7-git-send-email-jkallickal@emulex.com>
 <536AB13E.6080906@cs.wisc.edu>
 <0eb11761-3b46-44d0-b35a-16d121fe1df4@CMEXHTCAS2.ad.emulex.com>
 <20140602064601.GA6630@infradead.org>
 <1401736926.12939.13.camel@dabdike.int.hansenpartnership.com>
 <20140602193349.GA11555@infradead.org>
 <CA+55aFy+VTFqBi5aQLdB7=04wWmf+gvZzQ1vdrSEuscN7k3xGw@mail.gmail.com>
 <20140602200813.GA8118@infradead.org>
 <CA+55aFxGkJe9zaUtjGqU9Wy9_pepXUidKVM3oGjUYztCA8erAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38012 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaFBUco (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 16:32:44 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFxGkJe9zaUtjGqU9Wy9_pepXUidKVM3oGjUYztCA8erAA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "hch@infradead.org" <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "MinhDuc.Tran@Emulex.Com" <MinhDuc.Tran@emulex.com>, "jayamohank@gmail.com" <jayamohank@gmail.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Sony.John-N@Emulex.Com" <Sony.John-N@emulex.com>, "Jayamohan.Kallickal@Emulex.Com" <Jayamohan.Kallickal@emulex.com>

On Mon, Jun 02, 2014 at 01:24:22PM -0700, Linus Torvalds wrote:
> If it isn't a particularly large patch and doesn't have any other
> issues, I'd suggest just reverting it.
> 
> Particularly large patches can be worth undoing just to avoid
> unnecessary noise in "git blame" etc, but that's an issue mainly for
> things like whitespace crap that really touches a *lot* of code and so
> the noise is a big thing.

It's an smal and simple driver patch:

http://git.infradead.org/users/hch/scsi-queue.git/commitdiff/4f96827dd55981ec4bfcbc7584eb155bcd8d1849
