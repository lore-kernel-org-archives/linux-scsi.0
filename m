From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] remove ide-scsi
Date: Sat, 6 Dec 2008 15:06:25 +0000
Message-ID: <20081206150625.224aa97f@lxorguk.ukuu.org.uk>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>
	<20081203100643.GA29340@infradead.org>
	<1228316941.5551.6.camel@localhost.localdomain>
	<200812061551.08525.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48665 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752246AbYLFPGm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Dec 2008 10:06:42 -0500
In-Reply-To: <200812061551.08525.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org

> ide-scsi has been practically a dead code for a long time now (IIRC it has
> even been broken -- by some general kernel changes -- for few releases and
> nobody noticed, till Boaz discovered it while doing unrelated SCSI fixes)
> but I kept it on the live support anyway.  However there needs to be some
> limit to it, especially given that driver has been officially orphaned for
> over a year now and nobody stepped in...

And it basically still works. You've just removed some hardware support
for folks still trapped with the old IDE legacy drivers and some tape
drives etc.

I shall certainly be asking Linus not to apply your changeset.

Alan
