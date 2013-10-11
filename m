From: Christoph Hellwig <hch@lst.de>
Subject: Re: scsi-mq updated to latest linux-block/new-queue
Date: Fri, 11 Oct 2013 14:19:32 +0200
Message-ID: <20131011121932.GA18146@lst.de>
References: <1381345971.19256.461.camel@haakon3.risingtidesystems.com> <20131009194658.GA3066@dhcp-26-207.brq.redhat.com> <20131010191714.GA3098@lst.de> <20131010193240.GA17206@dhcp-26-207.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131010193240.GA17206@dhcp-26-207.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 10, 2013 at 09:32:41PM +0200, Alexander Gordeev wrote:
> I wonder, if blk-mq- prefix should remain?.. This s code seems pretty much
> generic to me.

Seems like nowdays you should just use the percpu-ida allocator directly,
Shaohua Li hast just sent patches to switch blk-mq over to it as well.
