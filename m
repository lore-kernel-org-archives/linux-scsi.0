From: =?ISO-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>
Subject: Re: What's a good basic SCSI controller these days?
Date: Sat, 13 Apr 2002 22:17:28 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020413214256.Y1734-100000@localhost.my.domain>
References: <E16wQrg-0000c4-00@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <E16wQrg-0000c4-00@the-village.bc.nu>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux@horizon.com, linux-scsi@vger.kernel.org


On Sat, 13 Apr 2002, Alan Cox wrote:

> > The Tekram DC3x5 appears to be the current low-end champion, and it h=
as
> > Linux support, but the driver is still separate from 2.4, and Kurt
> > Garloff still calls it beta, with some unresolved issues.
> > Adaptec is old reliable.  And reliably expensive.
>
> You've missed probably the largest supplier of good cheap cards - LSI L=
ogic
> (aka Symbios ex NCR). The SYM53c8xx stuff is really really good and the
> driver maintenance is excellent.

Thanks, Alan. Just I haven't had that much time for working on the Symbio=
s
drivers these latest 3 months :(. Note that the drivers have proven to be
very reliable and no new features were urgent to add. I have now updated
my O/Ses versions and will sync my sources with them.

About the DC3x5 controllers, Kurt's driver is probably just fine. But
these SCSI chips require 1 interrupt per SCSI phase change and certainly
to perform far more PCI IO operations per SCSI IO from the C code than fo=
r
Symbios chips and adaptec chips. This let me not recommend DC3x5
controllers for fast SCSI hard disks.

SCSI hard disks are very expensive compared to Ultra DMA ones. For
example, a IBM 7200 36 GB U160 SCSI disks costed me 250 euros compared to
a Maxtor 7200 60 GB Ultra DMA 133 that costed me 140 euros.

Users that want SCSI hard disks to give some expectable significant
advantage (given their unbelievable higher price compared to Ultra DMA
drives) over Ultra DMA ones should offord something better than a DC3X5
SCSI controller, in my opinion.

  G=E9rard.

