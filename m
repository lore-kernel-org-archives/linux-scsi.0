From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
Date: Fri, 15 Jun 2012 12:51:29 +0200
Message-ID: <4FDB13B1.8040100@kernel.dk>
References: <1339757457-15646-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339757457-15646-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On 06/15/2012 12:50 PM, Jan Kara wrote:
> Sometimes, warnings about ioctls to partition happen often enough that they
> form majority of the warnings in the kernel log and users complain. In some
> cases warnings are about ioctls such as SG_IO so it's not good to get rid of
> the warnings completely as they can ease debugging of userspace problems
> when ioctl is refused.
> 
> Since I have seen warnings from lots of commands, including some proprietary
> userspace applications, I don't think disallowing the ioctls for processes
> with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
> stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.

Agree, merged, finally.

-- 
Jens Axboe
