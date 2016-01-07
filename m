From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/35 v2] separate operations from flags in the
 bio/request structs
Date: Thu, 7 Jan 2016 14:13:41 +1100
Message-ID: <20160107031341.GC32200@dastard>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
 <yq14meqi2va.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq14meqi2va.fsf@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: mchristi@redhat.com, linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 06, 2016 at 08:40:09PM -0500, Martin K. Petersen wrote:
> >>>>> "Mike" == mchristi  <mchristi@redhat.com> writes:
> 
> Mike> The following patches begin to cleanup the request->cmd_flags and
> bio-> bi_rw mess. We currently use cmd_flags to specify the operation,
> Mike> attributes and state of the request. For bi_rw we use it for
> Mike> similar info and also the priority but then also have another
> Mike> bi_flags field for state. At some point, we abused them so much we
> Mike> just made cmd_flags 64 bits, so we could add more.
> 
> Mike> The following patches seperate the operation (read, write discard,
> Mike> flush, etc) from cmd_flags/bi_rw.
> 
> Mike> This patchset was made against linux-next from today Jan 5 2016.
> Mike> (git tag next-20160105).
> 
> Very nice work. Thanks for doing this!
> 
> I think it's a much needed cleanup. I focused mainly on the core block,
> discard, write same and sd.c pieces and everything looks sensible to me.
> 
> I wonder what the best approach is to move a patch set with this many
> stakeholders forward? Set a "speak now or forever hold your peace"
> review deadline?

I say just ask Linus to pull it immediately after the next merge
window closes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
