From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] fixes and cleanups for the new command allocation code
Date: Tue, 4 Feb 2003 21:15:16 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030204211516.A30419@beaverton.ibm.com>
References: <20030204162326.A30755@lst.de> <20030204081616.A24105@beaverton.ibm.com> <20030204175146.A31515@lst.de> <20030204091955.A24785@beaverton.ibm.com> <1044383605.2014.23.camel@mulgrave> <20030204202935.A325@lst.de> <1044399797.3484.15.camel@mulgrave> <20030204172505.A28812@beaverton.ibm.com> <1044410039.3485.61.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1044410039.3485.61.camel@mulgrave>; from James.Bottomley@steeleye.com on Tue, Feb 04, 2003 at 07:53:57PM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Feb 04, 2003 at 07:53:57PM -0600, James Bottomley wrote:
> On Tue, 2003-02-04 at 19:25, Patrick Mansfield wrote:

> But that's not how the block queue works: prep is actually called from
> elv_next_request().  Therefore, if you plug the queue in the request
> function when you're over the queue limit, you only get a single fully
> prepped request waiting in the queue, which, I think, is the desired
> behaviour.  Even if the queue is restarted because of I/O pressure, it
> will begin with the prepped request and re-block.

OK that sounds great, except we should not plug the queue since we
have outstanding IO.

> And the slave_{alloc,configure,destroy} needs fixing too.

What is broken?

-- Patrick Mansfield
