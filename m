From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Thin provisioning update
Date: Tue, 10 Nov 2009 08:16:49 -0500
Message-ID: <20091110131649.GA4516@infradead.org>
References: <1257308740-4729-1-git-send-email-martin.petersen@oracle.com> <20091109142051.GC4855@infradead.org> <20091109193409.GA26596@infradead.org> <yq13a4nos7y.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbZKJNQu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2009 08:16:50 -0500
Content-Disposition: inline
In-Reply-To: <yq13a4nos7y.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@kernel.dk, Christoph Hellwig <hch@infradead.org>, matthew@wil.cx, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

On Tue, Nov 10, 2009 at 12:37:37AM -0500, Martin K. Petersen wrote:
> >>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:
> 
> Christoph> So actually I'll take my previous comment back.  I think
> Christoph> these patches are good enough to put them in now to have
> Christoph> something we can build on.
> 
> Ok.  Jens, please queue the patch below.  And then we'll have to see
> about getting James to rebase and/or postpone the SCSI portion to round
> #2.

Can't we please get both patches in through one tree?  Everything else
is a bit of a pain to manage.

