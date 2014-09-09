From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/8] block: avoid to use q->flush_rq directly
Date: Tue, 9 Sep 2014 11:38:32 -0700
Message-ID: <20140909183832.GD16750@infradead.org>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
 <1410267949-21904-5-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1410267949-21904-5-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 09, 2014 at 09:05:45PM +0800, Ming Lei wrote:
> This patch trys to use local variable to access flush request,
> so that we can convert to per-queue flush machinery a bit easier.
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
