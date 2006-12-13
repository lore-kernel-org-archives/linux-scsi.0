From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-2.6.19-ge1036502 build #192 failed
Date: Wed, 13 Dec 2006 08:56:52 -0800
Message-ID: <20061213085652.69740bce.randy.dunlap@oracle.com>
References: <200612131305.47486.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet02.oracle.com ([141.146.126.229]:36296 "EHLO
	agminet02.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965006AbWLMRCX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Dec 2006 12:02:23 -0500
Received: from agminet01.oracle.com (agminet01.oracle.com [141.146.126.228])
	by agminet02.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id kBDH2C7S017101
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 13 Dec 2006 11:02:21 -0600
In-Reply-To: <200612131305.47486.toralf.foerster@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Wed, 13 Dec 2006 13:05:44 +0100 Toralf F=F6rster wrote:

>=20
> Hello,
>=20
> the build with the attached .config failed, make ends with:
> ...
>   CC      drivers/scsi/libiscsi.o
>   CC      drivers/scsi/iscsi_tcp.o
>   CC      drivers/scsi/advansys.o
> drivers/scsi/advansys.c:794:2: warning: #warning this driver is still=
 not properly converted to the DMA API
> drivers/scsi/advansys.c: In function `advansys_detect':
> drivers/scsi/advansys.c:4406: warning: `check_region' is deprecated (=
declared at include/linux/ioport.h:134)
> drivers/scsi/advansys.c: In function `AscSearchIOPortAddr11':
> drivers/scsi/advansys.c:9743: warning: `check_region' is deprecated (=
declared at include/linux/ioport.h:134)
> drivers/scsi/advansys.c: At top level:
> drivers/scsi/advansys.c:18219: error: elements of array `advansys_pci=
_tbl' have incomplete type
> drivers/scsi/advansys.c:18220: warning: excess elements in struct ini=
tializer
> drivers/scsi/advansys.c:18220: warning: (near initialization for `adv=
ansys_pci_tbl[0]')
> drivers/scsi/advansys.c:18220: warning: excess elements in struct ini=
tializer
> drivers/scsi/advansys.c:18220: warning: (near initialization for `adv=
ansys_pci_tbl[0]')
> ...
> drivers/scsi/advansys.c:18231: warning: (near initialization for `adv=
ansys_pci_tbl[5]')
> drivers/scsi/advansys.c:18231: warning: excess elements in struct ini=
tializer
> drivers/scsi/advansys.c:18231: warning: (near initialization for `adv=
ansys_pci_tbl[5]')
> make[2]: *** [drivers/scsi/advansys.o] Error 1
> make[1]: *** [drivers/scsi] Error 2
> make: *** [drivers] Error 2

Yes, I have posted a patch for advansys with PCI=3Dn,
but I don't know what has happened with it...
I looked in both scsi-misc and scsi-fixes git trees but
didn't see it there.


> Here's the config:
>=20
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.19
> # Wed Dec 13 12:16:31 2006
> #
> # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
> #
> # CONFIG_PCI is not set

---
~Randy
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
