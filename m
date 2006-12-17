From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC PATCH] m68k: switch to 53c700 driver
Date: Sun, 17 Dec 2006 17:28:37 -0500
Message-ID: <1166394517.9647.22.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be>
	 <20051007134232.GA6490@levanta.com>
	 <1128693232.5041.7.camel@laptop-lcs.localdomain>
	 <20051115095152.GA23470@infradead.org>
	 <20051115101709.GK7031@2004.bluespice.org>
	 <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com>
	 <20060707124444.GA11199@infradead.org> <20060709111648.GR15414@levanta.com>
	 <1152444304.5567.2.camel@kars.perseus.home>
	 <20061030111311.GA756@infradead.org>
	 <1162331224.7805.18.camel@kars.perseus.home>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:38250 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753589AbWLRJPY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Dec 2006 04:15:24 -0500
In-Reply-To: <1162331224.7805.18.camel@kars.perseus.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kars de Jong <jongk@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>, Richard Hirst <rhirst@levanta.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>

On Tue, 2006-10-31 at 22:47 +0100, Kars de Jong wrote:
> On ma, 2006-10-30 at 11:13 +0000, Christoph Hellwig wrote:
> > Any updates?  Honestly, I do not plan to touch the current 53c7xx/etc
> > mess in the upoming request_buffer transition, and unless the m68k
> > folks provide the new 53c700-based driver I'll just submit a patch to
> > rip 53c7xx and users out without replacement.
> 
> OK, here's the patch, without the m68k generic iomap changes.

Could you regenerate this against the current git-head?  I've tried
several merge points and I still can't get it to apply ... I suspect it
had additional m68k fixes in the original file.

Thanks,

James


