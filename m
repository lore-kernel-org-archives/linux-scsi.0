From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] virtio_blk: implement REQ_FLUSH/FUA support
Date: Mon, 16 Aug 2010 20:33:17 +0200
Message-ID: <20100816183317.GA28171@lst.de>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1281977523-19335-3-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, Tejun Heo <tj@kernle.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 16, 2010 at 06:52:00PM +0200, Tejun Heo wrote:
> From: Tejun Heo <tj@kernle.org>
> 
> Remove now unused REQ_HARDBARRIER support and implement REQ_FLUSH/FUA
> support instead.  A new feature flag VIRTIO_BLK_F_FUA is added to
> indicate the support for FUA.

I'm not sure it's worth it.  The pure REQ_FLUSH path works not and is
well tested with kvm/qemu.   We can still easily add a FUA bit, and
even a pre-flush bit if the protocol roundtrips matter in real life
benchmarking.
