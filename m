From: Christoph Hellwig <hch@lst.de>
Subject: Re: osst changes required to move forward to block request
Date: Tue, 7 Mar 2006 23:43:21 +0100
Message-ID: <20060307224321.GB17487@lst.de>
References: <20060206131944.GA1769@lst.de> <1139274141l.7464l.1l@athena.riede.org> <20060207091254.GA11691@infradead.org> <1139687216l.24984l.0l@athena.riede.org> <20060307115913.GA30421@infradead.org> <1141768417.3239.52.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:15575 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964829AbWCGWnb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2006 17:43:31 -0500
Content-Disposition: inline
In-Reply-To: <1141768417.3239.52.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Willem Riede <osst@riede.org>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Tue, Mar 07, 2006 at 03:53:37PM -0600, James Bottomley wrote:
> On Tue, 2006-03-07 at 11:59 +0000, Christoph Hellwig wrote:
> > James, could you put this into the scsi-misc tree so we don't have any ULD
> > using the scsi_request APIs anymore?
> 
> OK, done ... now could someone actually test it?

Willem tested it.
