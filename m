From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 7/7] blk-zoned: implement ioctls
Date: Tue, 27 Sep 2016 20:24:23 +0200
Message-ID: <20160927182423.GA22238@lst.de>
References: <1474888483-29762-1-git-send-email-damien.lemoal@hgst.com> <1474888483-29762-8-git-send-email-damien.lemoal@hgst.com> <20160926163752.GA13876@infradead.org> <CAJVOszCdwMhLyZAJAWDnDBziyAejxdwi5J-X197RXwNuvC82GA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55858 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933854AbcI0SY0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Sep 2016 14:24:26 -0400
Content-Disposition: inline
In-Reply-To: <CAJVOszCdwMhLyZAJAWDnDBziyAejxdwi5J-X197RXwNuvC82GA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: Christoph Hellwig <hch@infradead.org>, Damien Le Moal <damien.lemoal@hgst.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>

On Mon, Sep 26, 2016 at 06:12:24PM -0500, Shaun Tancheff wrote:
> Except our source locations are disjoint (stack and kcalloc'd).

Indeed.
