From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: linux-2.6.19-rc2-gc7a3bd17 build #90 failed
Date: Mon, 23 Oct 2006 07:46:58 -0600
Message-ID: <20061023134657.GG25210@parisc-linux.org>
References: <200610231526.48474.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:922 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1751955AbWJWNq7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Oct 2006 09:46:59 -0400
Content-Disposition: inline
In-Reply-To: <200610231526.48474.toralf.foerster@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Mon, Oct 23, 2006 at 03:26:46PM +0200, Toralf F=F6rster wrote:
> the build with the attached .config failed, make ends with:

What tree are you building?  In Linus' tree, advansys_pci_tbl is
declared as:

static struct pci_device_id advansys_pci_tbl[] __devinitdata =3D {

Seems like your tree has it defined as:

static struct pci_device_id advansys_pci_tbl[5] __devinitdata =3D {

>   CC      drivers/scsi/advansys.o
> drivers/scsi/advansys.c:794:2: warning: #warning this driver is still=
 not properly converted to the DMA API
> drivers/scsi/advansys.c: In function `advansys_detect':
> drivers/scsi/advansys.c:4406: warning: `check_region' is deprecated (=
declared at include/linux/ioport.h:133)
> drivers/scsi/advansys.c: In function `AscSearchIOPortAddr11':
> drivers/scsi/advansys.c:9743: warning: `check_region' is deprecated (=
declared at include/linux/ioport.h:133)
> ...
> drivers/scsi/advansys.c:18231: warning: excess elements in struct ini=
tializer
> drivers/scsi/advansys.c:18231: warning: (near initialization for `adv=
ansys_pci_tbl[5]')
> drivers/scsi/advansys.c:18231: warning: excess elements in struct ini=
tializer
> drivers/scsi/advansys.c:18231: warning: (near initialization for `adv=
ansys_pci_tbl[5]')
> make[2]: *** [drivers/scsi/advansys.o] Error 1
> make[1]: *** [drivers/scsi] Error 2
> make: *** [drivers] Error 2
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
