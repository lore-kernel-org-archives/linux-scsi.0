From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH block/for-3.17-fixes/core] blk-mq, percpu_ref:
	implement a kludge for SCSI blk-mq stall during probe
Date: Wed, 24 Sep 2014 10:23:48 +0200
Message-ID: <20140924082348.GB8894@lst.de>
References: <20140919113815.GA10791@lst.de> <541C8047.80705@kernel.dk> <20140923055554.GA10189@lst.de> <20140923055648.GD11740@mtj.dyndns.org> <20140923055924.GA10295@lst.de> <20140923060141.GF11740@mtj.dyndns.org> <20140923060906.GA10547@lst.de> <20140923061152.GI11740@mtj.dyndns.org> <5421968B.7080309@kernel.dk> <20140923192432.GA24441@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140923192432.GA24441@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Thanks, this fixes the boot stall for me.

Tested-by: Christoph Hellwig <hch@lst.de>
