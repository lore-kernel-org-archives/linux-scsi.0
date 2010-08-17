From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/5] virtio_blk: implement REQ_FLUSH/FUA support
Date: Tue, 17 Aug 2010 18:22:38 +0200
Message-ID: <4C6AB74E.7080909@kernel.org>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <1281977523-19335-3-git-send-email-tj@kernel.org> <20100816183317.GA28171@lst.de> <4C6A458B.5040407@kernel.org> <20100817132327.GA3347@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100817132327.GA3347@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com
List-Id: linux-scsi@vger.kernel.org

Hello,

On 08/17/2010 03:23 PM, Christoph Hellwig wrote:
>> Hmmm... the underlying storage could be md/dm RAIDs in which case FUA
>> should be cheaper than FLUSH.
> 
> If someone ever wrote a virtio-blk backend that sits directly ontop
> of the Linux block layer that would be true.  Of the five known
> virtio-blk backends all operate on normal files using the Posix I/O
> APIs, or the Linux aio API (optionally in qemu) or in-kernel
> vfs_read/vfs_write (vhost-blk).

Right.

> Given how little testing lguest gets compared to qemu I really don't
> want a protocol addition for it unless it really buys us something.
> Once we're done with this barrier conversion I plan into benchmarking
> FUA and a pre-flush tag on the command for virtio in real life setups,
> and see if it actually buys us anything.

Hmmm... yeah, we can drop it.  Michael, what do you think?

Thanks.

-- 
tejun
