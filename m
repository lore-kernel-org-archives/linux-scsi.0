From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] sym2: remove unkown data direction handling
Date: Tue, 2 Nov 2004 18:15:11 +0100
Message-ID: <20041102171511.GA1810@lst.de>
References: <20041102111835.GA29191@lst.de> <20041102170649.GB24690@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:24009 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261595AbUKBRPN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2004 12:15:13 -0500
Content-Disposition: inline
In-Reply-To: <20041102170649.GB24690@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, Nov 02, 2004 at 05:06:49PM +0000, Matthew Wilcox wrote:
> On Tue, Nov 02, 2004 at 12:18:35PM +0100, Christoph Hellwig wrote:
> > since 2.3 the LLDD gets the data direction passed down, so we don't
> > need to kludge around an unknown data direction anymore.  I've added
> > a BUG when we get an unkown data direction neverless, and it seems to
> > survive so far under low load.
> 
> I thought we could get an unknown data direction from certain ioctls?

Not anymore.  We could get the wrong direction from some older ioctls,
when not used as document but not an unkown one.
