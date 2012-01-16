From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 2/3] block: fail SCSI passthrough ioctls on partition
 devices
Date: Mon, 16 Jan 2012 09:51:09 +0100
Message-ID: <4F13E4FD.3070500@redhat.com>
References: <1326380489-9044-1-git-send-email-pbonzini@redhat.com> <1326380489-9044-3-git-send-email-pbonzini@redhat.com> <CA+55aFxuEzfAOL=pH1m7KQxdO1yzz=nGb2fU80AbysFd3J4Dvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab2APIvU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2012 03:51:20 -0500
In-Reply-To: <CA+55aFxuEzfAOL=pH1m7KQxdO1yzz=nGb2fU80AbysFd3J4Dvg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, stable@vger.kernel.org

On 01/15/2012 12:43 AM, Linus Torvalds wrote:
> Anyway, with the changes to print out warnings and still allow it for
> root, this all looked safe and nice, so they are in my tree now. I
> only noticed after applying them that you hadn't marked them with 'cc:
> stable@kernel.org', so we should probably point Greg at them. They are
> commits
>
>    577ebb374c78 block: add and use scsi_blk_cmd_ioctl
>    0bfc96cb7722 block: fail SCSI passthrough ioctls on partition devices
>    ec8013beddd7 dm: do not forward ioctls from logical volumes to the
> underlying device
>
> in my tree now.

I'll tweak them myself for stable based on what you committed, so that 
they do not require your ENOTTY/ENOIOCTLCMD change (i.e. with the uglier 
v1 implementation).

Thanks very much.

Paolo
