From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] target/iblock: use ilog2 to compute block size
Date: Wed, 22 Jun 2016 17:53:01 +0200
Message-ID: <8480462.cSbQVM4ZJM@wuerfel>
References: <20160622125534.1267407-1-arnd@arndb.de> <20160622133809.GA29657@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160622133809.GA29657@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday, June 22, 2016 6:38:09 AM CEST Christoph Hellwig wrote:
> This doesn't compute the block size, it computes the number of block
> in a block device. 

Right, that's at least what I planned to put in the $subject ;-)

> I think it would be useful to add a generic helper
> (e.g. in blkdev.h) as this calculation seems to be open coded in various
> places.

Good idea, I'll try to come up with a patch for that.

	Arnd
