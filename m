From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: iomapping a big endian area
Date: Tue, 05 Apr 2005 09:05:32 -0500
Message-ID: <1112709932.5764.6.camel@mulgrave>
References: <1112475134.5786.29.camel@mulgrave>
	 <20050403013757.GB24234@parcelfarce.linux.theplanet.co.uk>
	 <1112649465.5813.106.camel@mulgrave> <20050405072104.GA26208@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:27778 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261741AbVDEOFj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Apr 2005 10:05:39 -0400
In-Reply-To: <20050405072104.GA26208@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, 2005-04-05 at 08:21 +0100, Christoph Hellwig wrote:
> What I really don't like is that you still need ifdefs and wrappers to
> support BE and LE wired chips in the same driver.  Shouldn't you set the
> BE or LE flag at iomap() time and always use the same accessors?

No, if you look how it works.  On parisc, it can be either BE or LE
depending on the chip wiring.  There would be a case for selecting BE or
LE by #define, but there's no case I know today where we have a driver
that would always be BE.

James


