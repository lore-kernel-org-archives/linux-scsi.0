From: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Subject: Re: intel srcu42e, megaraid_mbox, 2.6.16.23, x86_64 - megaraid mbox: critical hardware error!
Date: Mon, 31 Jul 2006 14:15:12 +0200
Message-ID: <200607311415.12162.arekm@pld-linux.org>
References: <200607311107.36681.arekm@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outgoing3.smtp.agnat.pl ([193.239.44.85]:55180 "EHLO
	outgoing3.smtp.agnat.pl") by vger.kernel.org with ESMTP
	id S1750962AbWGaMPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2006 08:15:18 -0400
Received: from [83.18.80.218] (helo=[192.168.1.157] ident=matrix157)
	by tekla.agnat.pl with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.62)
	(envelope-from <arekm@pld-linux.org>)
	id 1G7Wg1-00014x-Je
	for linux-scsi@vger.kernel.org; Mon, 31 Jul 2006 14:15:17 +0200
In-Reply-To: <200607311107.36681.arekm@pld-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Monday 31 July 2006 11:07, Arkadiusz Miskiewicz wrote:
> Hi,
>
> I have Tyan Thunder K8SRE S2891 mainboard, Transport GT24 B2891 1U
> barebone system - 2 x dual core opteron 270, 6GB ram and Intel SRCU42=
E
> (PCI-E one) controller.
>
> The system has been set up (with kernel 2.6.16.23 SMP) and while comp=
iling
> kernel on it I got controller lockup. The problem is repeatable.
>
> I'm trying to compile 2.6.18rc3 + megaraid patches from mm kernel but=
 from
> changelog it doesn't seem that there is some important fix for this c=
ase.
>
> Any ideas?

It's seems that the problem is solved now. The problem was due to broke=
n=20
memory chip attached to intel srcu42e. Details here:
http://www.intel.com/support/motherboards/server/srcu42e/sb/CS-023123.h=
tm

We got another srcu42e with memory from another manufacturer and it see=
ms to=20
work properly.

> megaraid driver, firmware and bios versions below:
>
> megaraid cmm: 2.20.2.6 (Release Date: Mon Mar 7 00:01:03 EST 2005)
> megaraid: 2.20.4.7 (Release Date: Mon Nov 14 12:27:22 EST 2005)
> megaraid: probe new device 0x1000:0x0408:0x8086:0x0002: bus 3:slot 14=
:func
> 0 ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 19
> GSI 16 sharing vector 0xB1 and IRQ 16
> ACPI: PCI Interrupt 0000:03:0e.0[A] -> Link [LNK1] -> GSI 19 (level, =
high)
> -> IRQ 177 megaraid: fw version:[514P] bios version:[H431]
> Losing some ticks... checking if CPU frequency changed.
> scsi0 : LSI Logic MegaRAID driver
> scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
> scsi[0]: scanning scsi channel 1 [Phy 1] for non-raid devices
> scsi[0]: scanning scsi channel 2 [virtual] for logical drives
>   Vendor: MegaRAID  Model: LD 0 RAID5  280G  Rev: 514P
>   Type:   Direct-Access                      ANSI SCSI revision: 02

--=20
Arkadiusz Mi=B6kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
