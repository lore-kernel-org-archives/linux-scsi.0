From: Fabio Massimo Di Nitto <fabbione@fabbione.net>
Subject: Re: Linux Kernel 2.4.18 and 2.4.19 problems
Date: Fri, 19 Jul 2002 23:26:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D3883F6.7090608@fabbione.net>
References: <20020719192607.GA13880@stud.ntnu.no> <20020719140416.A25577@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: =?ISO-8859-1?Q?Thomas_Lang=E5s?= <tlan@stud.ntnu.no>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Patrick Mansfield wrote:

>On Fri, Jul 19, 2002 at 09:26:07PM +0200, Thomas Lang=E5s wrote:
> =20
>
>>qla2x00_set_info starts at address =3D f8836060
>>qla2x00: Found  VID=3D1077 DID=3D2200 SSVID=3D1077 SSDID=3D2
>>scsi1: Found a QLA2200  @ bus 2, device 0x4, irq 16, iobase 0xdc00
>>scsi(1): Allocated 4096 SRB(s)
>>PCI: Setting latency timer of device 02:04.0 to 64
>>scsi(1): Configure NVRAM parameters...
>>scsi(1): 64 Bit PCI Addressing Enabled
>>scsi(1): Verifying loaded RISC code...
>>scsi(1): Verifying chip...
>>scsi(1): Waiting for LIP to complete...
>>scsi(1): Cable is unplugged...
>>qla2x00: Found  VID=3D1077 DID=3D2200 SSVID=3D1077 SSDID=3D2
>>scsi2: Found a QLA2200  @ bus 2, device 0x5, irq 17, iobase 0xd800
>>scsi(2): Allocated 4096 SRB(s)
>>PCI: Setting latency timer of device 02:05.0 to 64
>>scsi(2): Configure NVRAM parameters...
>>scsi(2): 64 Bit PCI Addressing Enabled
>>scsi(2): Verifying loaded RISC code...
>>scsi(2): Verifying chip...
>>scsi(2): Waiting for LIP to complete...
>>scsi(2): Cable is unplugged...
>>
I have an HSG80 connected on the other side and I got this problem with
the beta6 drivers from qlogic.

The only way I made it working was using the kernel driver shipped with=
=20
rh7.3
that has been modified to support the HSG80 (according to the changelog=
 =20
supported
only by the beta6 series).

=46abio

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
