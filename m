From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 3/3] ide-pm: always pass 0 error to ide_complete_rq in
 ide_do_devset
Date: Wed, 26 Apr 2017 12:33:20 +0200
Message-ID: <6500755.RihOe6T0DR@amdc3058>
References: <20170426073422.14511-1-hch@lst.de>
 <20170426073422.14511-4-hch@lst.de>
 <CGME20170426103322epcas5p390d45ef01f24b5bfb457761f9c71a530@epcas5p3.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-block-owner@vger.kernel.org>
In-reply-to: <20170426073422.14511-4-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday, April 26, 2017 09:34:22 AM Christoph Hellwig wrote:
> The caller only looks at the scsi_request result field anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
