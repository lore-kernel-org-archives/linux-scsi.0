From: David Dillow <dillowda@ornl.gov>
Subject: Re: scsi: include linux/scatterlist.h to pick up ARCH_HAS_SG_CHAIN
Date: Mon, 17 Jan 2011 21:50:22 -0500
Message-ID: <1295319022.3051.84.camel@obelisk.thedillows.org>
References: <1295208759.2574.14.camel@obelisk.thedillows.org>
	 <4D340F49.6030604@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D340F49.6030604@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@suse.de
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-01-17 at 11:43 +0200, Boaz Harrosh wrote:
> > Another option is to potentially get rid of the ARCH_HAS_SG_CHAIN define
> > as all archs have it save m68knommu.
> 
> What's preventing m68knommu from chaining? this is pure C manipulations,
> what am I missing?

Hopefully someone else will know -- I didn't look very hard once I saw
that it had no arch-specific asm include directory that I could readily
find.

Thanks for taking a look,
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office
