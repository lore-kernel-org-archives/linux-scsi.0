From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 26/30] ext4: do not send discards as barriers
Date: Wed, 25 Aug 2010 18:00:32 +0200
Message-ID: <20100825160032.GC3229@lst.de>
References: <1282751267-3530-1-git-send-email-tj@kernel.org> <1282751267-3530-27-git-send-email-tj@kernel.org> <20100825155842.GA3229@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100825155842.GA3229@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 25, 2010 at 05:58:42PM +0200, Christoph Hellwig wrote:
> On Wed, Aug 25, 2010 at 05:47:43PM +0200, Tejun Heo wrote:
> > From: Christoph Hellwig <hch@infradead.org>
> > 
> > ext4 already uses synchronous discards, no need to add I/O barriers.
> 
> This needs the patch that Jan sent in reply to my initial version merged
> into it.

Actually the jbd2 patch needs it merged, but the point still stands.
