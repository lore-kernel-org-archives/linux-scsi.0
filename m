From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/5] virtio_blk: implement REQ_FLUSH/FUA support
Date: Wed, 18 Aug 2010 19:52:02 +0930
Message-ID: <201008181952.03093.rusty@rustcorp.com.au>
References: <1281977523-19335-1-git-send-email-tj@kernel.org> <4C6A458B.5040407@kernel.org> <20100817132327.GA3347@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100817132327.GA3347@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, mst@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 17 Aug 2010 10:53:27 pm Christoph Hellwig wrote:
> Given how little testing lguest gets compared to qemu I really don't
> want a protocol addition for it unless it really buys us something.
> Once we're done with this barrier conversion I plan into benchmarking
> FUA and a pre-flush tag on the command for virtio in real life setups,
> and see if it actually buys us anything.

Absolutely.  Lguest should follow, not lead!

Rusty.
