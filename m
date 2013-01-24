From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/13] sg_io: pass request_queue to blk_verify_command
Date: Thu, 24 Jan 2013 14:34:20 -0800
Message-ID: <20130124223420.GZ2373@mtj.dyndns.org>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
 <1359039649-17734-2-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1359039649-17734-2-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 24, 2013 at 04:00:37PM +0100, Paolo Bonzini wrote:
> Adjust the blk_verify_command function to let it look at per-queue
> data.  This will be done in the next patch.
> 
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Doug Gilbert <dgilbert@interlog.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@kernel.org
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
