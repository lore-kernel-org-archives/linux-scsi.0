From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] blk-sysfs: Add 'chunk_sectors' to sysfs attributes
Date: Wed, 20 Jul 2016 22:59:35 -0700
Message-ID: <20160721055935.GD14568@infradead.org>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
 <1468934439-93579-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468934439-93579-2-git-send-email-hare@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@hgst.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 19, 2016 at 03:20:34PM +0200, Hannes Reinecke wrote:
> The queue limits already have a 'chunk_sectors' setting, so
> we should be presenting it via sysfs.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks fine for 4.8 independent of any ZBC implications:

Reviewed-by: Christoph Hellwig <hch@lst.de>
