From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block/for-3.17-fixes/core] blk-mq, percpu_ref: implement
 a kludge for SCSI blk-mq stall during probe
Date: Tue, 23 Sep 2014 15:48:34 -0400
Message-ID: <20140923194834.GA14111@mtj.dyndns.org>
References: <541C8047.80705@kernel.dk>
 <20140923055554.GA10189@lst.de>
 <20140923055648.GD11740@mtj.dyndns.org>
 <20140923055924.GA10295@lst.de>
 <20140923060141.GF11740@mtj.dyndns.org>
 <20140923060906.GA10547@lst.de>
 <20140923061152.GI11740@mtj.dyndns.org>
 <5421968B.7080309@kernel.dk>
 <20140923192432.GA24441@mtj.dyndns.org>
 <5421C9FF.5030903@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5421C9FF.5030903@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Oops, I forgot to cc Kent.  Kent, the patch is at

 http://lkml.kernel.org/g/20140923192432.GA24441@mtj.dyndns.org

On Tue, Sep 23, 2014 at 01:29:03PM -0600, Jens Axboe wrote:
> The hack looks fine to me, if it passes Christophs boot stall test. The
> hack isn't THAT nasty, since you already have a series queued up to fix
> it for real for 3.18.

Yeah, then I can pull in block fixes branch into a percpu for-3.18
branch, revert the hack and then apply the patches to implement the
proper fix.

Thanks.

-- 
tejun
