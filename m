From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: scsi/arm/fas216.c compile error
Date: Mon, 11 Feb 2008 10:02:49 +0000
Message-ID: <20080211100249.GA10520@flint.arm.linux.org.uk>
References: <20080209000413.GE6505@cs181133002.pp.htv.fi> <47AEF6FD.8080801@panasas.com> <20080210135851.GB25703@flint.arm.linux.org.uk> <1202653224.3136.20.camel@localhost.localdomain> <20080210220200.GA26654@flint.arm.linux.org.uk> <1202683456.3136.77.camel@localhost.localdomain> <47B019CD.3060502@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55060 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbYBKKDi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Feb 2008 05:03:38 -0500
Content-Disposition: inline
In-Reply-To: <47B019CD.3060502@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <adrian.bunk@movial.fi>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Feb 11, 2008 at 11:47:57AM +0200, Boaz Harrosh wrote:
> On Mon, Feb 11 2008 at 0:44 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> Andrew this patch was in -mm for two month or so. I was under the impression
> that you have an arm cross compiler that tries to build every -mm kernel.
> Is it possible that for some reason this portion did not get compiled?
> Is there a place that one can inspect the output of -mm compilations, Specially
> for cross compiled ARCHs?

Having a patch sit in -mm for ARM doesn't mean a lot since there's no
guarantee that it'll get built, and that is because the ARM architecture
is very diverse; it's not possible to build a single kernel to support
everything.

So, when akpm builds a kernel for ARM, it's normally centered around one
particular ARM defconfig (maybe with allyconfig or allmodconfig afterwards)
but even that won't build all ARM specific code.

This is why we now have kautobuild - http://armlinux.simtec.co.uk/kautobuild/
That's the only way we can get decent compilation coverage.

That system isn't publically accessible (it's not even accessible to me)
and it only builds the mainline kernels.  Adding -mm to it might be
possible, but as I understand the situation, even though it uses things
like ccache, it can take about 10 or so hours to complete a set of builds.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
