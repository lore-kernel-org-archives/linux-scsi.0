From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [RFC: 2.6 patch] remove the broken SCSI_ACORNSCSI_3 driver
Date: Sun, 29 Jul 2007 16:22:48 +0100
Message-ID: <20070729152248.GB25431@flint.arm.linux.org.uk>
References: <20070729145915.GF16817@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764850AbXG2Pgs@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070729145915.GF16817@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@osdl.org>, spyro@f2s.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jul 29, 2007 at 04:59:15PM +0200, Adrian Bunk wrote:
> The SCSI_ACORNSCSI_3 driver:
> - has been marked as BROKEN for more than one year and
> - is still marked as BROKEN.
> 
> Drivers that had been marked as BROKEN for such a long time seem to be
> unlikely to be revived in the forseeable future.
> 
> But if anyone wants to ever revive this driver, the code is still
> present in the older kernel releases.

NAK.  I've had a patch to resurect it for some time.  Notice that this
merge window I applied some patches to the other acorn scsi drivers -
once I get enough time to separate out the changes I'll be applying
those patches.  It's relatively low priority for me though.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
