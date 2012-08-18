From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [patch 1/2]block: handle merged discard request
Date: Fri, 17 Aug 2012 23:06:16 -0400
Message-ID: <CAMM=eLcBMrOfhJZU2GsSnMXkmWZMemJcvTM6WPLiiXkysXHYiQ@mail.gmail.com>
References: <20120316073213.656519005@fusionio.com> <20120316073512.485027511@fusionio.com>
 <20120320162157.GE17071@redhat.com> <CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
 <4F69C62C.7020604@kernel.org> <yq18vitwejt.fsf@sermon.lab.mkp.net>
 <CANejiEX26=jqijgTwb0iLMw7WC7byF1o+whwp3K5CcY5_a8o8w@mail.gmail.com>
 <yq1zkb9uz1t.fsf@sermon.lab.mkp.net> <20120620085724.GA26295@infradead.org> <yq1fw9o3t5b.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48678 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab2HRDGh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Aug 2012 23:06:37 -0400
In-Reply-To: <yq1fw9o3t5b.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, linux-kernel@vger.kernel.org, neilb@suse.de, linux-scsi@vger.kernel.org

On Thu, Jun 21, 2012 at 11:46 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:
>
>>> There are several additional commands in the pipeline where the 1:1
>>> mapping between DMA size and block range is invalid. I want to get
>>> rid of the 1:1 assumption in general so we can handle any command
>>> without these evil workarounds.
>
> Christoph> What's the progress on getting these issues sorted out?
>
> This has bitrotted for a while. I'll put it on my list. I should finally
> have some bandwidth again next week...

Hey Martin,

I rebased (and fixed/tested) your writesame patches on v3.6-rc2 +
jens' for-linus branch, the git tree is available here:
https://github.com/snitm/linux/tree/writesame

I've also made the updated patchset available here:
http://people.redhat.com/msnitzer/patches/upstream/writesame/series.html

Should the writesame patches come before any discard merge or 1:1 DMA
and block range assumption fixes?
NOTE (for others besides martin):
http://people.redhat.com/msnitzer/patches/upstream/writesame/0001-block-Clean-up-merge-logic.patch
removes all the discard merge hacks; I think it provides a clean
baseline to then layer discard merge support back in -- but maybe
that's a flawed strategy?

Could be I've wasted a few hours by rebasing these patches...
regardless, it would be great if you could share what your plans are.

Thanks!
