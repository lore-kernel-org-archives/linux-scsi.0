From: Willem Riede <osst@riede.org>
Subject: Re: osst changes required to move forward to block request
Date: Tue, 07 Mar 2006 17:16:20 -0500
Message-ID: <1141769780l.26398l.0l@athena.riede.org>
References: <20060206131944.GA1769@lst.de>
	<1139274141l.7464l.1l@athena.riede.org>
	<20060207091254.GA11691@infradead.org>
	<1139687216l.24984l.0l@athena.riede.org>
	<20060307115913.GA30421@infradead.org>
	<1141768417.3239.52.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc12.comcast.net ([204.127.192.82]:15564 "EHLO
	rwcrmhc12.comcast.net") by vger.kernel.org with ESMTP
	id S1751580AbWCGWQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2006 17:16:34 -0500
In-Reply-To: <1141768417.3239.52.camel@mulgrave.il.steeleye.com> (from
	James.Bottomley@SteelEye.com on Tue Mar  7 16:53:37 2006)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 03/07/2006 04:53:37 PM, James Bottomley wrote:
> On Tue, 2006-03-07 at 11:59 +0000, Christoph Hellwig wrote:
> > James, could you put this into the scsi-misc tree so we don't have any ULD
> > using the scsi_request APIs anymore?
> 
> OK, done ... now could someone actually test it?

Well, it has been tested before I OKed it, but on top of that I'll retest it 
once it shows up in e.g. the -mm tree.

Regards, Willem Riede.
