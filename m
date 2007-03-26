From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: some PCMCIA SCSI drivers can be built *only* as modules
Date: Mon, 26 Mar 2007 15:35:47 -0500
Message-ID: <1174941347.3549.41.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0703250916090.22484@CPE00045a9c397f-CM001225dbafb6>
	 <4607CA5A.4040906@s5r6.in-berlin.de> <20070326200257.GA28622@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:50703 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751044AbXCZUgA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Mar 2007 16:36:00 -0400
In-Reply-To: <20070326200257.GA28622@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, "Robert P. J. Day" <rpjday@mindspring.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Mon, 2007-03-26 at 21:02 +0100, Christoph Hellwig wrote:
> > >   it would seem to make no sense that the "depends on" clause for this
> > > option includes "m", forcing this (and all other four entries in that
> > > Kconfig file, by the way) to be built as modules, while the help text
> > > for all five entries suggests you can select "y".
> 
> In the old days pcmcia drivers had to be modular because pcmcia required
> a lot of userspace setup.  It's not needed anymore these days and the
> dependencies can go.

I agree the non-legacy (CardBus and beyond) ones can be built in.  I
thought the legacy 8 and 16 bit type I and II still had to be modular
because they still need setting up.

James


