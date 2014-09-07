From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/6] blk-mq: initialize pdu of flush req explicitly
Date: Sun, 7 Sep 2014 20:49:56 +0200
Message-ID: <20140907184956.GB23026@lst.de>
References: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

This works fine for me, although I still don't really like it very much.

If you really want to go down the path of major surgery in this area we
should probably allocate a flush request per hw_ctx, and initialize it
using the normal init/exit functions.  If we want to have proper multiqueue
performance on devices needing flushes we'll need something like that anyway.
