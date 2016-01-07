From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/35 v2] separate operations from flags in
	the bio/request structs
Date: Wed, 06 Jan 2016 20:40:09 -0500
Message-ID: <yq14meqi2va.fsf@sermon.lab.mkp.net>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <1452027218-32303-1-git-send-email-mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	(mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org's message of "Tue, 5 Jan 2016 14:53:03 -0600")
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, philipp.reisner-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, osd-dev-yNzVSZO3znNg9hUCZPvPmw@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Mike" == mchristi  <mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

Mike> The following patches begin to cleanup the request->cmd_flags and
bio-> bi_rw mess. We currently use cmd_flags to specify the operation,
Mike> attributes and state of the request. For bi_rw we use it for
Mike> similar info and also the priority but then also have another
Mike> bi_flags field for state. At some point, we abused them so much we
Mike> just made cmd_flags 64 bits, so we could add more.

Mike> The following patches seperate the operation (read, write discard,
Mike> flush, etc) from cmd_flags/bi_rw.

Mike> This patchset was made against linux-next from today Jan 5 2016.
Mike> (git tag next-20160105).

Very nice work. Thanks for doing this!

I think it's a much needed cleanup. I focused mainly on the core block,
discard, write same and sd.c pieces and everything looks sensible to me.

I wonder what the best approach is to move a patch set with this many
stakeholders forward? Set a "speak now or forever hold your peace"
review deadline?

-- 
Martin K. Petersen	Oracle Linux Engineering
