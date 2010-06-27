From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request payload
Date: Sun, 27 Jun 2010 17:33:35 +0200
Message-ID: <20100627153335.GA25667@lst.de>
References: <20100627185927K.fujita.tomonori@lab.ntt.co.jp> <20100627193253P.fujita.tomonori@lab.ntt.co.jp> <20100627110712.GA14511@lst.de> <20100627212952D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:44535 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429Ab0F0Pec (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jun 2010 11:34:32 -0400
Content-Disposition: inline
In-Reply-To: <20100627212952D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@lst.de, snitzer@redhat.com, axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Sun, Jun 27, 2010 at 09:32:07PM +0900, FUJITA Tomonori wrote:
> On Sun, 27 Jun 2010 13:07:12 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > > How about this?
> > 
> > As I tried to explain before this utterly confuses the I/O completion
> > path.  With the patch applied even a simple mkfs.xfs that issues discard
> > just hangs.
> 
> Wired. I just tried mkfs.xfs against scsi_debug with my block patches
> (I saw one discard command). Seemed that it worked fine.

Doesn't work for me against either a real SSD or WRITE SAME support in
qemu.  But I think I didn't actually have your barrier patches applied,
so I'll try again with a clean tree.

