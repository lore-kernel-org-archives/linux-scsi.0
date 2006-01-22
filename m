From: Andrew Morton <akpm@osdl.org>
Subject: Re: AHA-7850 doesn't detect scanner anymore
Date: Sat, 21 Jan 2006 22:33:09 -0800
Message-ID: <20060121223309.223fcb71.akpm@osdl.org>
References: <200601211346.34426.gbruchhaeuser@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:49377 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750760AbWAVGda convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jan 2006 01:33:30 -0500
In-Reply-To: <200601211346.34426.gbruchhaeuser@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerrit =?ISO-8859-1?B?QnJ1Y2ho5HVzZXI=?= <gbruchhaeuser@gmx.de>
Cc: linux-scsi@vger.kernel.org

Gerrit Bruchh=E4user <gbruchhaeuser@gmx.de> wrote:
>
> Hello,
> my old "HP ScanJet IIc" used to work so perfectly but now the kernel =
can only=20
> see something at SCSI-ID 1, but is not able to detect the device prop=
erly :-(
>=20
> These are the 'kernel.log' entries after I switched on 'options aic7x=
xx=20
> aic7xxx=3Dverbose,periodic_otag' in modules.conf file :
>=20
> | Jan 21 13:17:18 gbpc PCI: Enabling device 0000:00:0d.0 (0116 -> 011=
7)
> | Jan 21 13:17:18 gbpc ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 17 =
(level,=20
> low) -> IRQ 185
> | Jan 21 13:17:18 gbpc ahc_pci:0:13:0: hardware scb 64 bytes; kernel =
scb 52=20
> bytes; ahc_dma 8 bytes
> | Jan 21 13:17:18 gbpc ahc_pci:0:13:0: Host Adapter Bios disabled.  U=
sing=20
> default SCSI device parameters
> | Jan 21 13:17:18 gbpc scsi12 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA=
 DRIVER,=20
> Rev 7.0
> | Jan 21 13:17:18 gbpc <Adaptec 2902/04/10/15/20C/30C SCSI adapter>
> | Jan 21 13:17:18 gbpc aic7850: Single Channel A, SCSI Id=3D7, 3/253 =
SCBs
> | Jan 21 13:17:18 gbpc
> | Jan 21 13:17:33 gbpc (scsi12:A:0:0): Saw Selection Timeout for SCB =
0x3
> | Jan 21 13:17:34 gbpc (scsi12:A:1:0): SCB 2: requests Check Status
> | Jan 21 13:17:34 gbpc (scsi12:A:1:0): Handled Residual of 36 bytes
> | Jan 21 13:17:34 gbpc (scsi12:A:1:0): Sending Sense
> | Jan 21 13:17:34 gbpc (scsi12:A:1:0): Handled Residual of 36 bytes
> | Jan 21 13:17:34 gbpc (scsi12:A:1:0): SCB 3: requests Check Status
> | Jan 21 13:17:34 gbpc (scsi12:A:1:0): Handled Residual of 36 bytes
> | Jan 21 13:17:34 gbpc (scsi12:A:1:0): Sending Sense
> | Jan 21 13:17:34 gbpc (scsi12:A:1:0): Handled Residual of 36 bytes
> | Jan 21 13:17:35 gbpc (scsi12:A:1:0): SCB 2: requests Check Status
> | Jan 21 13:17:35 gbpc (scsi12:A:1:0): Handled Residual of 36 bytes
> | Jan 21 13:17:35 gbpc (scsi12:A:1:0): Sending Sense
> | Jan 21 13:17:35 gbpc (scsi12:A:1:0): Handled Residual of 36 bytes
> | Jan 21 13:17:35 gbpc (scsi12:A:2:0): Saw Selection Timeout for SCB =
0x3
> | Jan 21 13:17:35 gbpc (scsi12:A:3:0): Saw Selection Timeout for SCB =
0x2
> | Jan 21 13:17:36 gbpc (scsi12:A:4:0): Saw Selection Timeout for SCB =
0x3
> | Jan 21 13:17:36 gbpc (scsi12:A:5:0): Saw Selection Timeout for SCB =
0x2
> | Jan 21 13:17:36 gbpc (scsi12:A:6:0): Saw Selection Timeout for SCB =
0x3
>=20
>=20
> The SCSI-terminator is properly attached to the scanner and the wires=
 are okay=20
> as well. Is there a way to find-out more what actually causes the pro=
blem?
>=20

What is the version number of the failing kernel?

What is the version number of the most recent kernel which behaved
correctly?
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
