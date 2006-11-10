From: Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 2/2] libsas fails to compile on s390
Date: Fri, 10 Nov 2006 00:39:08 -0800
Message-ID: <20061110003908.ac98ee66.akpm@osdl.org>
References: <200611090357.kA93vA1u004099@shell0.pdx.osdl.net>
	<20061109003407.f2c5ea5b.akpm@osdl.org>
	<20061110075050.GD7129@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:31959 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1424118AbWKJIja (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Nov 2006 03:39:30 -0500
In-Reply-To: <20061110075050.GD7129@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, schwidefsky@de.ibm.com

On Fri, 10 Nov 2006 08:50:50 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Thu, Nov 09, 2006 at 12:34:07AM -0800, Andrew Morton wrote:
> > > Explicitly include scatterlist.h in sas_internal.h to avoid the implicit
> > > include dependency via the pci.h header.  For s390 the scatterlist.h header
> > > is not included because CONFIG_PCI=n.
> > err, please ignore this one....
> > [...]
> > distcc[16143] ERROR: compile drivers/scsi/libsas/sas_phy.c on bix/32 failed
> > make[1]: *** [drivers/scsi/libsas/sas_phy.o] Error 1
> > make: *** [drivers/scsi/libsas/sas_phy.o] Error 2
> 
> Strange... compiles fine for me.

The above was with x86, iirc.

> But maybe we should simply merge this one
> instead?
> 
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.19-rc5/2.6.19-rc5-mm1/broken-out/git-sas-kconfig-fix.patch

The original failure which we're tryimg to fix here occurred with that
patch applied.

Oh well.

