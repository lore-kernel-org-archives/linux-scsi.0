From: Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH 06/32] xen blkback: prepare for bi_rw split
Date: Mon, 09 Nov 2015 12:00:48 +0800
Message-ID: <56401A70.7090504@oracle.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
	<1446674909-5371-7-git-send-email-mchristi@redhat.com>
	<20151107101713.GB12117@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
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


On 11/07/2015 06:17 PM, Christoph Hellwig wrote:
> A little offtopic for this patch, but can some explain this whole
> mess about bios in Xen blkfront?  We can happily do partial completions
> at the request later.
> 
> Also since the blk-mq conversion the call to blk_end_request_all is

This will be fixed after my next blk-mq patch series which also modified the recover path.

> completely broken, so it doesn't look like this code path is exactly
> well tested.
>

Thanks,
-Bob
