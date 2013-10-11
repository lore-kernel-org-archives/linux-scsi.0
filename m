From: Jens Axboe <axboe@kernel.dk>
Subject: Re: scsi-mq updated to latest linux-block/new-queue
Date: Fri, 11 Oct 2013 08:23:28 -0600
Message-ID: <525809E0.10403@kernel.dk>
References: <1381345971.19256.461.camel@haakon3.risingtidesystems.com> <20131009194658.GA3066@dhcp-26-207.brq.redhat.com> <20131010191714.GA3098@lst.de> <20131010193240.GA17206@dhcp-26-207.brq.redhat.com> <20131011121932.GA18146@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131011121932.GA18146@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Alexander Gordeev <agordeev@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 10/11/2013 06:19 AM, Christoph Hellwig wrote:
> On Thu, Oct 10, 2013 at 09:32:41PM +0200, Alexander Gordeev wrote:
>> I wonder, if blk-mq- prefix should remain?.. This s code seems pretty much
>> generic to me.
> 
> Seems like nowdays you should just use the percpu-ida allocator directly,
> Shaohua Li hast just sent patches to switch blk-mq over to it as well.

Yeah, that was on the list of things to do and then test.


-- 
Jens Axboe
