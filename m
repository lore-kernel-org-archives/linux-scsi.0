From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 1/2] sg_io: pass request_queue to blk_verify_command
Date: Tue, 13 Nov 2012 09:38:11 -0800
Message-ID: <20121113173811.GA19014@mtj.dyndns.org>
References: <1352827513-29890-1-git-send-email-pbonzini@redhat.com>
 <1352827513-29890-2-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1352827513-29890-2-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 13, 2012 at 06:25:12PM +0100, Paolo Bonzini wrote:
> Adjust the blk_verify_command function to let it look at per-queue
> data.  This will be done in the next patch.
> 
> Cc: linux-scsi@vger.kernel.org
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Ric Wheeler <rwheeler@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
