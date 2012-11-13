From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/2] sg_io: introduce unpriv_sgio queue flag
Date: Tue, 13 Nov 2012 09:38:34 -0800
Message-ID: <20121113173834.GB19014@mtj.dyndns.org>
References: <1352827513-29890-1-git-send-email-pbonzini@redhat.com>
 <1352827513-29890-3-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1352827513-29890-3-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 13, 2012 at 06:25:13PM +0100, Paolo Bonzini wrote:
> This queue flag will let unprivileged users send any SG_IO command to the
> device, without any filtering.  This makes it possible to run a program
> where you want to access the full range of SCSI commands, while still
> running as confined as possible.  With this patch, such a program will
> not need the CAP_SYS_RAWIO capability anymore, and will also not be
> able to send SCSI commands to a partition (which would affect the full
> disk).
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
