From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] block: add flag for single-threaded submission
Date: Wed, 20 Jul 2016 22:54:31 -0700
Message-ID: <20160721055431.GB14568@infradead.org>
References: <1468936978-9124-1-git-send-email-hare@suse.de>
 <1468936978-9124-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468936978-9124-2-git-send-email-hare@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel-redhat.com@suse.de, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 19, 2016 at 04:02:56PM +0200, Hannes Reinecke wrote:
> Some devices (most notably SMR drives) support only
> one I/O stream eg for ensuring ordered I/O submission.
> This patch adds a new block queue flag
> 'BLK_QUEUE_SINGLE' to support these devices.

We'll need a blk-mq implementation of this flag as well before it can
be merged.
