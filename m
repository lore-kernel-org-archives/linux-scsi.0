From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RESEND][PATCH 1/2] lib/scatterlist: Make ARCH_HAS_SG_CHAIN an
 actual Kconfig
Date: Sat, 22 Mar 2014 21:44:24 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1403222142560.18573@ionos.tec.linutronix.de>
References: <1395512032-20575-1-git-send-email-lauraa@codeaurora.org> <1395512032-20575-2-git-send-email-lauraa@codeaurora.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ia64-owner@vger.kernel.org>
In-Reply-To: <1395512032-20575-2-git-send-email-lauraa@codeaurora.org>
Sender: linux-ia64-owner@vger.kernel.org
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org, linux390@de.ibm.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 22 Mar 2014, Laura Abbott wrote:

> Rather than have architectures #define ARCH_HAS_SG_CHAIN in an architecture
> specific scatterlist.h, make it a proper Kconfig option and use that
> instead. At same time, remove the header files are are now mostly
> useless and just include asm-generic/scatterlist.h.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

For the x86 part:

Acked-by: Thomas Gleixner <tglx@linutronix.de>
