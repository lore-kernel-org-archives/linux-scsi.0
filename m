From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 06/32] xen blkback: prepare for bi_rw split
Date: Sat, 7 Nov 2015 09:04:18 -0500
Message-ID: <20151107140410.GA5091@x230.dumpdata.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
	<1446674909-5371-7-git-send-email-mchristi@redhat.com>
	<20151107101713.GB12117@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
Content-Disposition: inline
In-Reply-To: <20151107101713.GB12117@infradead.org>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, mchristi@redhat.com, linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On Sat, Nov 07, 2015 at 02:17:13AM -0800, Christoph Hellwig wrote:
> A little offtopic for this patch, but can some explain this whole
> mess about bios in Xen blkfront?  We can happily do partial completions
> at the request later.

Not sure I follow. There are a couple of patches that are touching
Xen block code right now - the multi-queue, the ones in xen-tip
(which look to have be merged on Wednesday) and this one.

And oddly enough I never got copied on this original patch.
> 
> Also since the blk-mq conversion the call to blk_end_request_all is
> completely broken, so it doesn't look like this code path is exactly
> well tested.
