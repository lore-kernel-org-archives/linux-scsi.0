From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: 2.6.9 aacraid hangup
Date: Fri, 22 Oct 2004 08:20:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <60807403EABEB443939A5A7AA8A7458B40B78D@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:34978 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S271261AbUJVMUc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 08:20:32 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Lukas Hejtmanek <xhejtman@mail.muni.cz>, linux-scsi@vger.kernel.org

Contact Adaptec technical support, you may have a bad card, bad Motherb=
oard PCI bus or power supply, SCSI bus issues, or other H/W problems. D=
rive compatibility (requiring Drive F/W changes) may also be an issue s=
o make sure you list the actual drives model and release when you conta=
ct them.

I believe the latest released F/W for this card is 7244, but I may be m=
istaken. Not sure if 6011 had the high priority cache flush problem (ca=
using the card to be reticent for periods into the minutes) that plague=
s us on some of the earlier F/W releases of the Dell ROMB products when=
 introduced to faster and faster host processors. One way of checking t=
his out is to turn off the card's cache (both read and write).

Sincerely -- Mark Salyzyn

-----Original Message-----
=46rom: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org] On Behalf Of Lukas Hejtmanek
Sent: Thursday, October 21, 2004 7:33 PM
To: linux-scsi@vger.kernel.org
Subject: 2.6.9 aacraid hangup

Hello,

I'm using vanilla kernel 2.6.9 and ASR 2200S card with firmware 6011.

I have 1 P4 Xeon (HT enabled) and SMP configured kernel with 1GB of RAM=
=2E

8 SCSI HDD is connected to this card in HW RAID 5 array.

If I do:

dd if=3D/dev/sda of=3D/dev/null bs=3D1M count=3D1204 &
dd if=3D/dev/sda of=3D/dev/null bs=3D1M count=3D1024 skip=3D2000

then with VERY high probability system hangs. It responds that disks we=
nt
offline and no more i/o operation successes.

I have 2 partitions there. Witch EXT3 filesystem and with XFS filesyste=
m.

Is there something I could do?=20

(please cc me as I'm not in the list)

--=20
Luk=E1=B9 Hejtm=E1nek
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
