From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 00/42] v7: separate operations from flags in the
 bio/request structs
Date: Fri, 15 Apr 2016 15:44:32 -0400
Message-ID: <20160415194432.GA30077@redhat.com>
References: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mchristi@redhat.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 15 2016 at  3:15pm -0400,
mchristi@redhat.com <mchristi@redhat.com> wrote:

> The following patches begin to cleanup the request->cmd_flags and
> bio->bi_rw mess. We currently use cmd_flags to specify the operation,
> attributes and state of the request. For bi_rw we use it for similar
> info and also the priority but then also have another bi_flags field
> for state. At some point, we abused them so much we just made cmd_flags
> 64 bits, so we could add more.
> 
> The following patches seperate the operation (read, write discard,
> flush, etc) from cmd_flags/bi_rw.
> 
> This patchset was made against linux-next from today April 15
> (git tag next-20160415).
> 
> I put a git tree here:
> https://github.com/mikechristie/linux-kernel.git
> The patches are in the op branch.
> 
> v7:
> 1. Fix broken feature_flush/fua use.
> 
> v6 and maybe hopfully the last version:
> 1. Adapt patch 41 to Jens's QUEUE_FLAG_WC/FUA patchset.

Why are you blasting out the entire patchset for updates to individual
patches at the end of the series?

Mail is cheap but look at how wide you're repeatedly spamming this
series.

Also, look at what you've done to the dm-devel patchwork:
https://patchwork.kernel.org/project/dm-devel/list/?state=*

Just sayin'... ;)
