From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 7/8] be2iscsi: Fix processing cqe for cxn whose endpoint
 is freed
Date: Mon, 2 Jun 2014 13:24:22 -0700
Message-ID: <CA+55aFxGkJe9zaUtjGqU9Wy9_pepXUidKVM3oGjUYztCA8erAA@mail.gmail.com>
References: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
	<1399340492-2136-7-git-send-email-jkallickal@emulex.com>
	<536AB13E.6080906@cs.wisc.edu>
	<0eb11761-3b46-44d0-b35a-16d121fe1df4@CMEXHTCAS2.ad.emulex.com>
	<20140602064601.GA6630@infradead.org>
	<1401736926.12939.13.camel@dabdike.int.hansenpartnership.com>
	<20140602193349.GA11555@infradead.org>
	<CA+55aFy+VTFqBi5aQLdB7=04wWmf+gvZzQ1vdrSEuscN7k3xGw@mail.gmail.com>
	<20140602200813.GA8118@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:42557 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaFBUYX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 16:24:23 -0400
Received: by mail-ve0-f170.google.com with SMTP id db11so5877320veb.29
        for <linux-scsi@vger.kernel.org>; Mon, 02 Jun 2014 13:24:22 -0700 (PDT)
In-Reply-To: <20140602200813.GA8118@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "MinhDuc.Tran@Emulex.Com" <MinhDuc.Tran@emulex.com>, "jayamohank@gmail.com" <jayamohank@gmail.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "Sony.John-N@Emulex.Com" <Sony.John-N@emulex.com>, "Jayamohan.Kallickal@Emulex.Com" <Jayamohan.Kallickal@emulex.com>

On Mon, Jun 2, 2014 at 1:08 PM, hch@infradead.org <hch@infradead.org> wrote:
>
> It's reverting a patch that just doesn't fix a problem fully, so the
> prime reviewer and the patch author decided to withdraw it.  It won't
> cause any kind of problem during bisection.

If it isn't a particularly large patch and doesn't have any other
issues, I'd suggest just reverting it.

Particularly large patches can be worth undoing just to avoid
unnecessary noise in "git blame" etc, but that's an issue mainly for
things like whitespace crap that really touches a *lot* of code and so
the noise is a big thing.

              Linus
