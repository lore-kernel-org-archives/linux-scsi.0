From: Bernd Schubert <bernd-schubert@gmx.de>
Subject: Re: I/O errors on 6TB device
Date: Sat, 16 Dec 2006 17:28:13 +0100
Message-ID: <200612161728.14093.bernd-schubert@gmx.de>
References: <em0nro$njf$1@sea.gmane.org> <1166282914.2878.2.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54805 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161138AbWLPQ2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Dec 2006 11:28:19 -0500
In-Reply-To: <1166282914.2878.2.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsil.com>

> > [17179726.100000]  sda:<6>sd 0:0:1:0: SCSI error: return code =3D 0=
xb0000
> > [17179726.132000] end_request: I/O error, dev sda, sector 126911016=
88
>
> This is definitely a fusion driver error: it's DID_SOFT_ERROR, which
> that driver returns for a variety of firmware related conditions or
> transfer underruns.
>
> I've cc'd the fusion people to see if they can help you diagnose it
> further.
>
> James

James, many thanks for your help. I will try to do a firmware update on=
=20
Monday, maybe that helps. Of course, we also appreciate any help furthe=
r help=20
from LSI/MPT.

Thanks again,
Bernd

PS: Since the controller hardware might be important now, its an onboar=
d=20
controller on a Tyan S2880 mainboard.

0000:02:0a.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030=
 PCI-X=20
=46usion-MPT Dual Ultra320 SCSI (rev 07)
        Subsystem: LSI Logic / Symbios Logic: Unknown device 1000
        Flags: bus master, 66MHz, medium devsel, latency 72, IRQ 19
        I/O ports at a400 [size=3D256]
        Memory at fc9d0000 (64-bit, non-prefetchable) [size=3D64K]
        Memory at fc9c0000 (64-bit, non-prefetchable) [size=3D64K]
        Expansion ROM at fc700000 [disabled] [size=3D1M]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=3D=
0/0=20
Enable-
        Capabilities: [68]
0000:02:0a.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1030=
 PCI-X=20
=46usion-MPT Dual Ultra320 SCSI (rev 07)
        Subsystem: LSI Logic / Symbios Logic: Unknown device 1000
        Flags: bus master, 66MHz, medium devsel, latency 72, IRQ 20
        I/O ports at a800 [size=3D256]
        Memory at fc9f0000 (64-bit, non-prefetchable) [size=3D64K]
        Memory at fc9e0000 (64-bit, non-prefetchable) [size=3D64K]
        Expansion ROM at fc800000 [disabled] [size=3D1M]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=3D=
0/0=20
Enable-
        Capabilities: [68]

--=20
Bernd Schubert
PCI / Theoretische Chemie
Universit=E4t Heidelberg
INF 229
69120 Heidelberg

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
