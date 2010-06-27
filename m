From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request payload
Date: Sun, 27 Jun 2010 13:07:12 +0200
Message-ID: <20100627110712.GA14511@lst.de>
References: <20100627174721D.fujita.tomonori@lab.ntt.co.jp> <20100627092652.GA11625@lst.de> <20100627185927K.fujita.tomonori@lab.ntt.co.jp> <20100627193253P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:33189 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754812Ab0F0LHk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jun 2010 07:07:40 -0400
Content-Disposition: inline
In-Reply-To: <20100627193253P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@lst.de, snitzer@redhat.com, axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org

> How about this?

As I tried to explain before this utterly confuses the I/O completion
path.  With the patch applied even a simple mkfs.xfs that issues discard
just hangs.

