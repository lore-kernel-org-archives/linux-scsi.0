From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC 1/2] block: implement an unprep function corresponding
 directly to prep
Date: Wed, 30 Jun 2010 13:23:09 -0400
Message-ID: <20100630172308.GA14409@redhat.com>
References: <1277917264.2839.153.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab0F3RXY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 13:23:24 -0400
Content-Disposition: inline
In-Reply-To: <1277917264.2839.153.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, dm-devel@redhat.com

On Wed, Jun 30 2010 at  1:01pm -0400,
James Bottomley <James.Bottomley@suse.de> wrote:

> So this is more directly what I'm thinking.  It gives us an exactly
> correct place to hang the discard allocation in SCSI.  The next patch
> shows a potential implementation in sd.
> 
> I think it should avoid all the leaks people have been seeing trying to
> move the discard allocation/free into scsi.  I also think it should
> facilitate sending discard through SCSI as a REQ_TYPE_FS.

Thanks james!

I'll look to take this template and layer in Christoph's approach to
pushing the page allocation down into SCSI.

I'll also look at Tomo's REQ_TYPE_FS changes for discard.

I'll report back as soon as I have something.

Mike
