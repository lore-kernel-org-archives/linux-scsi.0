From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] remove ide-scsi
Date: Wed, 3 Dec 2008 14:02:56 +0000
Message-ID: <20081203140256.2e414d9c@lxorguk.ukuu.org.uk>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>
	<20081203100643.GA29340@infradead.org>
	<150283e90812030531o764b53b8w5bc655085ca4f106@mail.gmail.com>
	<20081203135550.GC25548@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58454 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750763AbYLCODO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 09:03:14 -0500
In-Reply-To: <20081203135550.GC25548@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Willem Riede <osst@riede.org>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bzolnier@gmail.com, James.Bottomley@hansenpartnership.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

> > You are right. There are IDE versions of the OnStream drives that need ide-scsi.
> > There are also SCSI versions of the OnStream, which work with osst directly.
> 
> Why can't osst / libata support the IDE versions of the OnStream drives?
> What code needs to be written?

They should work just fine that way.
