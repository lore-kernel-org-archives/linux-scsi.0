From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 90/91] block: fail SCSI passthrough ioctls on partition
 devices
Date: Sun, 05 Feb 2012 23:44:57 +0100
Message-ID: <4F2F0669.3000601@redhat.com>
References: <0635750f5f06ed2ca212b91fcb5c4483@local> <20120205220953.312427771@pcw.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120205220953.312427771@pcw.home.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ben Hutchings <ben@decadent.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

On 02/05/2012 11:11 PM, Willy Tarreau wrote:
> Signed-off-by: Ben Hutchings<ben@decadent.org.uk>
> Signed-off-by: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
> [wt: no scsi_cmd_blk_ioctl in 2.6.27, change callers instead. cciss is OK,
>   ub,virtio_blk,ide-floppy,sd need fixing, cdrom&st can be ignored ]

NACK, you aren't fixing virtio-blk to call scsi_verify_blk_ioctl, are you?

You need to backport the patch that introduced scsi_cmd_blk_ioctl, 
which, in fact was in the same patch series as this one.

Paolo
