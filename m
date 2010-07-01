From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC 1/2] block: implement an unprep function corresponding
 directly to prep
Date: Thu, 1 Jul 2010 10:47:12 +0900
Message-ID: <20100701104653O.fujita.tomonori@lab.ntt.co.jp>
References: <1277917264.2839.153.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:35776 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab0GABrp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 21:47:45 -0400
In-Reply-To: <1277917264.2839.153.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: snitzer@redhat.com, hch@lst.de, axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Wed, 30 Jun 2010 12:01:04 -0500
James Bottomley <James.Bottomley@suse.de> wrote:

> So this is more directly what I'm thinking.  It gives us an exactly
> correct place to hang the discard allocation in SCSI.  The next patch
> shows a potential implementation in sd.

Yeah, making the prep_rq_fn API symmetrical makes sense lots.

 
> I think it should avoid all the leaks people have been seeing trying to
> move the discard allocation/free into scsi.  I also think it should
> facilitate sending discard through SCSI as a REQ_TYPE_FS.

I think so. If I can figure out why qemu scsi driver is broken, the
job is done.

I'll see how this patchset works and update my FS discard patchset on
the top of this.
