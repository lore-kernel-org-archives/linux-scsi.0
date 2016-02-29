From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 00/35 v4] separate operations from flags in the
	bio/request structs
Date: Mon, 29 Feb 2016 11:30:22 -0600
Message-ID: <56D4802E.3090507@cs.wisc.edu>
References: <1456343292-14535-1-git-send-email-mchristi@redhat.com>
	<20160229171339.GA17755@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20160229171339.GA17755@infradead.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>, mchristi@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

On 02/29/2016 11:13 AM, Christoph Hellwig wrote:
> Any reason you've dropped my ACK for the previous version?

Sorry. I think I accidentally dropped it when I rebased back over to
linux-next. It looks like it only got stuck on the first patch. I will
fix that up on the resend for those kbuild errors.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
