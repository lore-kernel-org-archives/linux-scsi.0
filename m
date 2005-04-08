From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid 2.6: Address sparse warnings
Date: Fri, 8 Apr 2005 14:41:58 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B010A9E60@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:34187 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261850AbVDHSmC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2005 14:42:02 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>, Christoph Hellwig <hch@infradead.org>
Cc: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Al Viro sez:
> > > +#define LE32_ALL_ONES ((__force __le32)0xffffffff)
> > I don't like having this in an actual driver.  It might make sense
to
> > either have this in a common header or actually allowing to assign
all
> > ones to __l32*/__be* variables.  Al?
> It doesn't make sense, period.  Use cpu_to_le32(~0U) - calculations
will
> be done at compile time and it's self-documenting.  Definition above
> is not more efficient or easier to type, so...

As long as this is guaranteed on all platforms to do the right thing ...
paranoid about compiler optimizations. MarkH, this should be an easy
regroup :-)

Sincerely -- Mark Salyzyn
