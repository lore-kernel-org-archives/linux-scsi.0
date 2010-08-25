From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 26/30] ext4: do not send discards as barriers
Date: Wed, 25 Aug 2010 17:58:42 +0200
Message-ID: <20100825155842.GA3229@lst.de>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
	<1282751267-3530-27-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1282751267-3530-27-git-send-email-tj@kernel.org>
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

On Wed, Aug 25, 2010 at 05:47:43PM +0200, Tejun Heo wrote:
> From: Christoph Hellwig <hch@infradead.org>
> 
> ext4 already uses synchronous discards, no need to add I/O barriers.

This needs the patch that Jan sent in reply to my initial version merged
into it.
