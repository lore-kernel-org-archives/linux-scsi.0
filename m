From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] use q->prep_rq_fn for flush requests instead of
 q->prepare_flush_fn()
Date: Fri, 02 Jul 2010 09:53:35 +0200
Message-ID: <4C2D9AFF.7010401@kernel.dk>
References: <1278056005-25438-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20100702075248.GB21266@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100702075248.GB21266@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@suse.de, hch@lst.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2010-07-02 09:52, Christoph Hellwig wrote:
> On Fri, Jul 02, 2010 at 04:33:23PM +0900, FUJITA Tomonori wrote:
>> We could kill q->prepare_flush_fn(). Except for ide, all the users
>> just mark flush requests. They can use REQ_FLUSH flag instead. Ide can
>> do like SCSI.
> 
> Yes, and I think you should go all the way to kill it instead of
> keeping both APIs around.  Otherwise the patchset looks good to me.

Fully agree, lets get rid of ->prepare_flush_fn().


-- 
Jens Axboe
