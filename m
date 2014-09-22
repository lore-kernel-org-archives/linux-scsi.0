From: Jens Axboe <axboe@kernel.dk>
Subject: Re: two more fixes for block/for-linus
Date: Mon, 22 Sep 2014 08:06:49 -0600
Message-ID: <54202CF9.7050303@kernel.dk>
References: <1411394371-16254-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411394371-16254-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2014-09-22 07:59, Christoph Hellwig wrote:
> Fix two regressions with the timer/blk_mq_start_request changes found
> when using scsi-mq on an ATA device.
>
> Note that given how late we are in the cycle I wonder if we really should
> push the changes in block/for-linus to Linus in this cycle.  The race
> part of the timer fixes is extremly narrow, and the reserved request
> part of it requires an out of tree driver update to trigger it, so it
> doesn't sound super criticial.

I was planning on pushing it out today, I've run a lot of testing on it 
internally last week. Ho hum, let me think about it...

-- 
Jens Axboe
