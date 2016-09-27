From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 7/7] blk-zoned: implement ioctls
Date: Tue, 27 Sep 2016 14:23:50 -0700
Message-ID: <20160927212350.GA32067@infradead.org>
References: <1474888209-29445-8-git-send-email-damien.lemoal@hgst.com>
 <20160927185617.19405-1-shaun@tancheff.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33220 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752781AbcI0VX4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2016 17:23:56 -0400
Content-Disposition: inline
In-Reply-To: <20160927185617.19405-1-shaun@tancheff.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaun Tancheff <shaun@tancheff.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Damien Le Moal <damien.lemoal@hgst.com>, shaun.tancheff@seagate.com

Damien, can you do a repost of the whole series with the
header reshuffled included?  Except for that and the trivial
kcalloc bit the series looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
