From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 29/30] block: remove the BLKDEV_IFL_BARRIER
	flag
Date: Wed, 25 Aug 2010 17:59:20 +0200
Message-ID: <20100825155920.GB3229@lst.de>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
	<1282751267-3530-30-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1282751267-3530-30-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: jeremy@goop.org, jack@suse.cz, snitzer@redhat.com, mst@redhat.com, linux-ide@vger.kernel.org, dm-devel@redhat.com, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, hch@lst.de, k-ueda@ct.jp.nec.com, vst@vlnb.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, rusty@rustcorp.com.au, linux-raid@vger.kernel.org, swhiteho@redhat.com, chris.mason@oracle.com, tytso@mit.edu, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, rwheeler@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 25, 2010 at 05:47:46PM +0200, Tejun Heo wrote:
> From: Christoph Hellwig <hch@infradead.org>
> 
> Remove support for barriers on discards, which is unused now.  Also
> remove the DISCARD_NOBARRIER I/O type in favour of just setting the
> rw flags up locally in blkdev_issue_discard.
> 
> tj: Also remove DISCARD_SECURE and use REQ_SECURE directly.

REQ_SECURE was just added for mmc.  I assume they plan to submit the
driver support soon.
