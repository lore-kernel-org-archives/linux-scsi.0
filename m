From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V4 12/16] blokc: mq-deadline: Introduce dispatch helpers
Date: Sun, 24 Sep 2017 17:21:49 +0200
Message-ID: <20170924152149.GD16608@lst.de>
References: <20170924070247.25560-1-damien.lemoal@wdc.com> <20170924070247.25560-13-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43650 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752244AbdIXPVu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 24 Sep 2017 11:21:50 -0400
Content-Disposition: inline
In-Reply-To: <20170924070247.25560-13-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

> +static struct request *
> +deadline_next_request(struct deadline_data *dd, int data_dir)
> +{

	if (WARN_ON_ONCE(data_dir != READ && data_dir != WRITE))
		return NULL;

> +	return dd->next_rq[data_dir];
> +}
> +

Else looks fine to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
