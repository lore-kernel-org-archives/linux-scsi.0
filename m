From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC 1/2] block: implement an unprep function corresponding
 directly to prep
Date: Wed, 30 Jun 2010 19:51:14 +0200
Message-ID: <4C2B8412.6040807@kernel.dk>
References: <1277917264.2839.153.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34679 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937Ab0F3RvP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 13:51:15 -0400
In-Reply-To: <1277917264.2839.153.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, dm-devel@redhat.com

On 30/06/10 19.01, James Bottomley wrote:
> So this is more directly what I'm thinking.  It gives us an exactly
> correct place to hang the discard allocation in SCSI.  The next patch
> shows a potential implementation in sd.
> 
> I think it should avoid all the leaks people have been seeing trying to
> move the discard allocation/free into scsi.  I also think it should
> facilitate sending discard through SCSI as a REQ_TYPE_FS.

This is so much better than the other hacks, thanks for doing this.

-- 
Jens Axboe

