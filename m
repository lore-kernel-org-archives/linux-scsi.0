From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC PATCH] SCSI: split Kconfig menu into two
Date: Fri, 14 Sep 2007 21:00:33 +0200
Message-ID: <20070914190033.GA4003@uranus.ravnborg.org>
References: <p73fy1p9m57.fsf@bingen.suse.de> <1189371621.3526.28.camel@localhost.localdomain> <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org> <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de> <20070914151522.GL3563@stusta.de> <46EAAAC1.3050409@s5r6.in-berlin.de> <tkrat.d922469e152fe0f3@s5r6.in-berlin.de> <tkrat.913e8b183cdf7888@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:57736 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036AbXINS7L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2007 14:59:11 -0400
Content-Disposition: inline
In-Reply-To: <tkrat.913e8b183cdf7888@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

Hi Stefan.

Such a patch really calls for some minimal unifacation among
the architectures.

> 
>  arch/alpha/Kconfig            |    2 
>  arch/arm/Kconfig              |    2 
>  arch/avr32/Kconfig            |    2 
>  arch/blackfin/Kconfig         |    2 
>  arch/cris/Kconfig             |    2 
>  arch/frv/Kconfig              |    2 
>  arch/i386/Kconfig             |    2 
>  arch/ia64/Kconfig             |    2 
>  arch/m32r/Kconfig             |    2 
>  arch/m68k/Kconfig             |    2 
>  arch/m68knommu/Kconfig        |    2 
>  arch/mips/Kconfig             |    2 
>  arch/parisc/Kconfig           |    2 
>  arch/powerpc/Kconfig          |    2 
>  arch/ppc/Kconfig              |    2 
>  arch/s390/Kconfig             |    2 
>  arch/sh/Kconfig               |    2 
>  arch/sh64/Kconfig             |    2 
>  arch/sparc/Kconfig            |    2 
>  arch/sparc64/Kconfig          |    2 
>  arch/um/Kconfig               |    2 
>  arch/v850/Kconfig             |    2 
>  arch/x86_64/Kconfig           |    4 
>  arch/xtensa/Kconfig           |    2 


Exactly the same change for all architectures.
IT would be good to introduce a common file that contains
some of the shared stuff from the different architectures.
We could start out simple with:

arch/Kconfig.arch:

source "net/Kconfig"
source "drivers/Kconfig"
source "fs/Kconfig"
source "security/Kconfig"
source "crypto/Kconfig"
source "lib/Kconfig"


And then source it in all relevant arch Kconfig files.
It is not all that can use it but most do.
A trivial task but one small step towards unification between
the architectures on the Kconfig level.

	Sam
