From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] use q->prep_rq_fn for flush requests instead of
 q->prepare_flush_fn()
Date: Fri, 2 Jul 2010 03:52:48 -0400
Message-ID: <20100702075248.GB21266@infradead.org>
References: <1278056005-25438-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1278056005-25438-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@suse.de, axboe@kernel.dk, hch@lst.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 02, 2010 at 04:33:23PM +0900, FUJITA Tomonori wrote:
> We could kill q->prepare_flush_fn(). Except for ide, all the users
> just mark flush requests. They can use REQ_FLUSH flag instead. Ide can
> do like SCSI.

Yes, and I think you should go all the way to kill it instead of
keeping both APIs around.  Otherwise the patchset looks good to me.
