From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [KJ] [PATCH][RESUBMIT][11/21] drivers/scsi/* - compile warning
	cleanup
Date: Tue, 15 Feb 2005 09:32:06 -0600
Message-ID: <1108481526.5539.17.camel@mulgrave>
References: <42113C2D.5008.52BF1B@localhost>
	 <20050215103959.GB19930@infradead.org>
	 <20050215140902.GM29917@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:49887 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261756AbVBOPce (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 10:32:34 -0500
In-Reply-To: <20050215140902.GM29917@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, Stephen Biggs <yrgrknmxpzlk@gawab.com>, kernel-janitors@lists.osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-02-15 at 14:09 +0000, Matthew Wilcox wrote:
> Actually, for 53c700, I think this *is* the right fix.  Unless we want to
> move it away from using host->base (which is marked as "legacy crap", so
> maybe we do).  I guess pushing it into hostdata is the preferred way?

Well, no it's not really.

If you look at 53c700, what it's actually doing is precisely what the
iomem resources do (i.e. trying to use a cookie or flag to determine if
it's doing mem or io reads/writes).  What needs to happen to this driver
is to convert it to using the new iomem infrastructure and remove its
original implementation.

James


