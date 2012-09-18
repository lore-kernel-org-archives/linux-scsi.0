From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 22/24] scsi: eesox: use __iomem pointers for MMIO
Date: Tue, 18 Sep 2012 08:09:58 +0000
Message-ID: <201209180809.58542.arnd@arndb.de>
References: <201209150800.35605.arnd@arndb.de> <201209151030.44105.arnd@arndb.de> <20120917220334.GU12245@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120917220334.GU12245@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Monday 17 September 2012, Russell King - ARM Linux wrote:
> In both of my replies, I've said "as x86 does".  We need to follow
> x86's behaviour here, which is as I've quoted - it's not a matter
> that "I need to make up my mind" - my mind is already well made up.
> That is, we need to follow x86 here.
> 
> That is, const volatile void __iomem * for reads, and volatile void
> __iomem * for writes.

Ok, I'll keep the patch in the series then, as it only changes the
pointer that we do an MMIO write on, not the ones for MMIO read.

	Arnd
