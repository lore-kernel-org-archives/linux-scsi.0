From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 3/3] ide-pm: always pass 0 error to ide_complete_rq in
 ide_do_devset
Date: Wed, 26 Apr 2017 10:39:08 -0400 (EDT)
Message-ID: <20170426.103908.1730143387784680812.davem@davemloft.net>
References: <20170426073422.14511-1-hch@lst.de>
        <20170426073422.14511-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170426073422.14511-4-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: hch@lst.de
Cc: axboe@kernel.dk, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Wed, 26 Apr 2017 09:34:22 +0200

> The caller only looks at the scsi_request result field anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: David S. Miller <davem@davemloft.net>
