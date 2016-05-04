From: Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/42] v7: separate operations from flags in
	the bio/request structs
Date: Wed, 04 May 2016 13:58:57 -0400
Message-ID: <x49a8k5aen2.fsf@segfault.boston.devel.redhat.com>
References: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
	<x49d1p2c1nx.fsf@segfault.boston.devel.redhat.com>
	<572A36BF.3070208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <572A36BF.3070208-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Mike Christie's message of "Wed, 4
	May 2016 12:51:59 -0500")
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Mike Christie <mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, osd-dev-yNzVSZO3znNg9hUCZPvPmw@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Mike Christie <mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> On 05/03/2016 03:44 PM, Jeff Moyer wrote:
>> Hi, Mike,
>> 
>> That git tree doesn't seem to exist.  I did manage to apply your patch
>> set on top of next-20160415, though.
>> 
>> So... what testing did you do? ;-) I ran into the following problems
>
> I normally run xfstests and run it on my daily workstation and laptop. I
> did not do this for every FS this time and hit a regression.
>
> What FS were you using?

I'm using xfs, scsi disk, no blk-mq, no dm.

>> - git clone fails
>> - yum segfaults
>
> In v7/v6, I missed a new submit_bio call, so I hit issues like the two
> above. I have this fixed in the next version.

OK, does this mean you're posting another version, or you already did
and I somehow missed it?

>> - many blktrace/blkparse issues, including incorrect cpu recorded in
>>   traces, null task names, and blkparse outputting nothing for a trace
>>   file several gigabytes in size.
>
> I will double check for these issues.

Thanks.  I'll stop digging for now, then.

Cheers,
Jeff
