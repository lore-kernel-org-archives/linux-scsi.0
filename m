From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fusion: streamline ->queuecommand
Date: Sat, 2 Oct 2004 15:49:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041002154948.A14224@infradead.org>
References: <20041002081355.GA13643@lst.de> <20041002133915.GR16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:30470 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266427AbUJBOuL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Oct 2004 10:50:11 -0400
Content-Disposition: inline
In-Reply-To: <20041002133915.GR16153@parcelfarce.linux.theplanet.co.uk>; from matthew@wil.cx on Sat, Oct 02, 2004 at 02:39:15PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@lst.de>, Emoore@lsil.com, linux-scsi@vger.kernel.org

On Sat, Oct 02, 2004 at 02:39:15PM +0100, Matthew Wilcox wrote:
> Of course, at some point, Fusion should be switched over to use the
> scsi_transport_spi domain validation code ... not urgent, just an
> item for the long-term todo list.

absolutely.  Also the dv threaad handling in fusion is rather bogus,
and moving to the genric one would fix that nicely.

