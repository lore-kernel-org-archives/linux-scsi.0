From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] mpt3sas, mpt2sas: fix scsi_add_host error handling
	problems in _scsih_probe
Date: Fri, 18 Jul 2014 11:46:49 +0200
Message-ID: <20140718094649.GC2121@lst.de>
References: <20140717193707.1924.87867.stgit@beardog.cce.hp.com> <20140717193926.1924.21344.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140717193926.1924.21344.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Elliott <elliott@hp.com>
Cc: axboe@kernel.dk, abhijit.mahajan@avagotech.com, kmo@datarainc.com, nagalakshmi.nandigama@avagotech.com, asamymuthupa@micron.com, snitzer@redhat.com, JBottomley@parallels.com, relliott@beardog.cce.hp.com, sreekanth.reddy@avagotech.com, praveen.krishnamoorthy@avagotech.com, agordeev@redhat.com, scameron@beardog.cce.hp.com, tom.leiming@gmail.com, sbradshaw@micron.com, hch@lst.de, m@bjorling.me, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 17, 2014 at 02:39:30PM -0500, Robert Elliott wrote:
> In _scsih_probe, propagate the return value from scsi_add_host.
> In mpt3sas, avoid calling list_del twice if that returns an
> error, which causes list_del corruption warnings if an error
> is returned.
> 
> Tested with blk-mq and scsi-mq patches to properly cleanup
> from and propagate blk_mq_init_rq_map errors.
> 
> Signed-off-by: Robert Elliott <elliott@hp.com>

Looks good.  It would be even better if we'd have proper error values
returned from mpt2/3sas_base_attach as well.

Reviewed-by: Christoph Hellwig <hch@lst.de>
