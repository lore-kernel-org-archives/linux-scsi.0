From: devzero@web.de
Subject: Re:aacraid broken in git
Date: Sat, 19 Apr 2008 11:04:17 +0200
Message-ID: <245566938@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmmailgate04.web.de ([217.72.192.242]:32786 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbYDSJEU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Apr 2008 05:04:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

what was the last working kernel for you?
any chance to bisect ?


List:       linux-scsi
Subject:    aacraid broken in git
=46rom:       "Yinghai Lu" <yhlu.kernel () gmail ! com>
Date:       2008-04-19 1:55:42
Message-ID: 86802c440804181855t615a5616g62d083695ca8ea08 () mail ! gmai=
l ! com
[Download message RAW]

4/18 2.6-git got

Calling initcall 0xffffffff80f10f97: aac_init+0x0/0x95()
Adaptec aacraid driver 1.1-5[2455]-ms
ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [LNEB] -> GSI 18 (level, lo=
w) -> IRQ
 18
PCI: Enabling bus mastering for device 0000:04:00.0
PCI: Setting latency timer of device 0000:04:00.0 to 64
AAC0: kernel 5.2-0[15594]
AAC0: monitor 5.2-0[15594]
AAC0: bios 5.2-0[15594]
AAC0: serial AA0009
AAC0: Non-DASD support enabled.
AAC0: 64bit support enabled.
AAC0: 64 Bit DAC enabled
aac_fib_free, XferState !=3D 0, fibptr =3D 0xffff8108232e0000, XferStat=
e =3D 0x810ad
ACPI: PCI interrupt for device 0000:04:00.0 disabled
aacraid: probe of 0000:04:00.0 failed with error -4
initcall 0xffffffff80f10f97: aac_init+0x0/0x95() returned 0.
initcall 0xffffffff80f10f97 ran for 286 msecs: aac_init+0x0/0x95()


Linux LBSuse 2.6.25-x86-latest.git-01659-g1f8551e #106 SMP Fri Apr 18
18:24:39 PDT 2008 x86_64 x86_64 x86_64 GNU/Linux

YH

______________________________________________________
Bis 50 MB Dateianh=E4nge? Kein Problem!
http://freemail.web.de/club/landingpage.htm/?mc=3D025556

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
