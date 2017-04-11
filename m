From: Mike Christie <mchristi@redhat.com>
Subject: Re: RFC: remove REQ_OP_WRITE_SAME
Date: Tue, 11 Apr 2017 11:49:46 -0500
Message-ID: <58ED092A.5080901@redhat.com>
References: <20170410160807.23674-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170410160807.23674-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, martin.petersen@oracle.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, target-devel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On 04/10/2017 11:07 AM, Christoph Hellwig wrote:
> Now that we are using REQ_OP_WRITE_ZEROES for all zeroing needs in the
> kernel there is very little use left for REQ_OP_WRITE_SAME.  We only
> have two callers left, and both just export optional protocol features
> to remote systems: DRBD and the target code.
> 
> Do we have any major users of those?  If not removing it will clean up
> a few warts in the block layer.

I added the iblock write same support because for RBD/ceph we were going
to pass it from rbd down to the OSD. We are using tcmu right now, so we
no longer need iblock support.
