From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Wed, 02 May 2012 12:37:23 +0200
Message-ID: <4FA10E63.5000804@kernel.dk>
References: <1335953452-10460-1-git-send-email-jack@suse.cz> <4FA1092E.9090603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FA1092E.9090603@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/02/2012 12:15 PM, Paolo Bonzini wrote:
> Il 02/05/2012 12:10, Jan Kara ha scritto:
>> Sometimes, warnings about ioctls to partition happen often enough that they
>> form majority of the warnings in the kernel log and users complain. In some
>> cases warnings are about ioctls such as SG_IO so it's not good to get rid of
>> the warnings completely as they can ease debugging of userspace problems
>> when ioctl is refused.
>>
>> Since I have seen warnings from lots of commands, including some proprietary
>> userspace applications, I don't think disallowing the ioctls for processes
>> with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
>> stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.
> 
> NACK.  I would bet that all the warnings you've seen are for ioctl that
> would have failed anyway with ENOTTY.
> 
> The right fix has already been posted, we've been carrying it in RHEL
> for over six months and not a single bug has been seen.

I don't remember seeing the "right" fix. The messages are really
annoying, so lets please get it resubmitted so that we can merge it.

-- 
Jens Axboe
