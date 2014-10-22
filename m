From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND
Date: Wed, 22 Oct 2014 08:00:42 -0600
Message-ID: <5447B88A.4020007@kernel.dk>
References: <1413963026-25974-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1413963026-25974-1-git-send-email-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/22/2014 01:30 AM, Jan Kara wrote:
> When sg_scsi_ioctl() fails to prepare request to submit in
> blk_rq_map_kern() we jump to a label where we just end up copying
> (luckily zeroed-out) kernel buffer to userspace instead of reporting
> error. Fix the problem by jumping to the right label.

Thanks Jan, applied.

-- 
Jens Axboe
