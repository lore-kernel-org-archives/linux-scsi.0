From: Martin Michlmayr <tbm@cyrius.com>
Subject: Re: advansys broken (at least) on ARM and MIPS
Date: Thu, 3 Jan 2008 16:55:49 +0100
Message-ID: <20080103155549.GA29400@deprecation.cyrius.com>
References: <20080103074353.GD22470@deprecation.cyrius.com> <1199373667.3122.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sorrow.cyrius.com ([65.19.161.204]:2621 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbYACP4N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jan 2008 10:56:13 -0500
Content-Disposition: inline
In-Reply-To: <1199373667.3122.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>

Adding Russell King to CC who can hopefully answer James' question
below.

* James Bottomley <James.Bottomley@HansenPartnership.com> [2008-01-03 0=
9:21]:
> On Thu, 2008-01-03 at 08:43 +0100, Martin Michlmayr wrote:
> > Commit 9d511a4b29de6764931343d03e493f2e04df0271 removed the "depend=
s
> > on BROKEN || X86_32" line from advansys' Kconfig entry.  I'm not su=
re
> > that was such a great idea - the module doesn't compile at least on
> > ARM and MIPS:
> >=20
> > ARM:
> >=20
> >   CC [M]  drivers/scsi/advansys.o
> > drivers/scsi/advansys.c:71:2: warning: #warning this driver is stil=
l not properly converted to the DMA
> >  API
> > drivers/scsi/advansys.c: In function =E2=80=98AdvBuildCarrierFreeli=
st=E2=80=99:
> > drivers/scsi/advansys.c:6486: warning: =E2=80=98virt_to_bus=E2=80=99=
 is deprecated (declared at include/asm/memory.h:1
> > 92)
> > drivers/scsi/advansys.c:6486: warning: =E2=80=98virt_to_bus=E2=80=99=
 is deprecated (declared at include/asm/memory.h:1
> > 92)
> > drivers/scsi/advansys.c:6486: warning: =E2=80=98virt_to_bus=E2=80=99=
 is deprecated (declared at include/asm/memory.h:1
> > 92)
> > ...
> > drivers/scsi/advansys.c: In function =E2=80=98advansys_get_sense_bu=
ffer_dma=E2=80=99:
> > drivers/scsi/advansys.c:9885: error: implicit declaration of functi=
on =E2=80=98dma_cache_sync=E2=80=99
>=20
> That error doesn't look to tbe the fault of the driver.
> dma_cache_sync() is a piece of the DMA API it looks like ARM doesn't
> implement?
>=20
> James
>=20

--=20
Martin Michlmayr
http://www.cyrius.com/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
