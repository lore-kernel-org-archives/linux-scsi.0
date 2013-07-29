From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [RFC/RFT PATCH 0/5] mm: ARM nobootmem and few dma_mask fixes
Date: Mon, 29 Jul 2013 14:40:12 +0100
Message-ID: <20130729134012.GK24642@n2100.arm.linux.org.uk>
References: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com> <20130726151021.GU24642@n2100.arm.linux.org.uk> <51F2A3AA.4060801@ti.com> <20130729111503.GG24642@n2100.arm.linux.org.uk> <51F66D94.9060706@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51F66D94.9060706@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chris Ball <cjb@laptop.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 29, 2013 at 09:26:44AM -0400, Santosh Shilimkar wrote:
> On Monday 29 July 2013 07:15 AM, Russell King - ARM Linux wrote:
> > Would you mind putting them all in the patch system, I can add the acks
> > should anyone supply them later, and I'll repost them along with my set
> > of dma-mask patches.  Thanks.
> > 
> Done.
> 7794/1, 7795/1, 7796/1, 7797/1, 7798/1, 7799/1
> 
> Didn't know how to get XXXX/1,2,3,4... pushed into the tracker.
> BTW, I have also pushed the patched on my git tree branch [1] just
> in case you or some one needs it.

Thanks.  I'd prefer not to have them as stable commits yet because should
we get acks from Jens, Jejb or cjb, we will need to add their acks to them.

My dma-masks branch is still very much unstable at the moment (which is
why its not published) but I shall be posting the patches during this
week.
