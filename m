From: Bernd Schubert <bernd-schubert@web.de>
Subject: 2.6.7 aic7xxx oops
Date: Thu, 1 Jul 2004 16:31:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200407011631.22587.bernd-schubert@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.uni-heidelberg.de ([129.206.100.212]:7315 "EHLO
	relay.uni-heidelberg.de") by vger.kernel.org with ESMTP
	id S265530AbUGAOb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2004 10:31:28 -0400
Received: from euklid.pci.uni-heidelberg.de (euklid.pci.uni-heidelberg.de [129.206.21.104])
	by relay.uni-heidelberg.de (8.12.10/8.12.10) with ESMTP id i61EVOIY020932
	for <linux-scsi@vger.kernel.org>; Thu, 1 Jul 2004 16:31:24 +0200 (MET DST)
Received: from bernd by euklid.pci.uni-heidelberg.de with local (Exim 3.35 #1 (Debian))
	id 1Bg2ax-0000XI-00
	for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2004 16:31:23 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

on modprobing the aic7xxx module I just got this oops:


Unable to handle kernel paging request at virtual address d08ae620
 printing eip:
c024e642
*pde =3D 0f87b067
Oops: 0002 [#1]
PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: aic7xxx mga uhci_hcd ohci_hcd md eeprom w83781d i2c_=
sensor=20
i2c_isa i2c_piix4 i2c_core
CPU:    0
EIP:    0060:[<c024e642>]    Not tainted
EFLAGS: 00010286   (2.6.7-tc1)=20
EIP is at kobject_add+0xc2/0x100
eax: c04f5948   ebx: c04f58e4   ecx: d08ae620   edx: d0897340
esi: c04f592c   edi: d0897324   ebp: c1c71f28   esp: c1c71f18
ds: 007b   es: 007b   ss: 0068
Process modprobe (pid: 1983, threadinfo=3Dc1c70000 task=3Dc1e11a60)
Stack: c04f5950 d0897324 ffffffea 00000000 c1c71f40 c024e69d d0897324 d=
0897324=20
       d0897324 c04f58e0 c1c71f58 c02c03d3 d0897324 d08972e0 00000000 d=
0897388=20
       c1c71f74 c0258686 d0897304 d0897374 c04b7ae8 00000000 d0897180 c=
1c71f80=20
Call Trace:
 [<c0108725>] show_stack+0x75/0x90
 [<c0108885>] show_registers+0x125/0x180
 [<c0108a1b>] die+0xab/0x170
 [<c011c238>] do_page_fault+0x1e8/0x535
 [<c010837d>] error_code+0x2d/0x40
 [<c024e69d>] kobject_register+0x1d/0x50
 [<c02c03d3>] bus_add_driver+0x43/0xb0
 [<c0258686>] pci_register_driver+0x76/0xa0
 [<d08846cd>] ahc_linux_pci_init+0xd/0x30 [aic7xxx]
 [<d087b96e>] ahc_linux_detect+0x4e/0xa0 [aic7xxx]
 [<d084b00d>] ahc_linux_init+0xd/0x22 [aic7xxx]
 [<c013fb9f>] sys_init_module+0x15f/0x2f0
 [<c01071e9>] sysenter_past_esp+0x52/0x79

Code: 89 11 8b 47 28 8b 18 8d 4b 48 89 c8 ba ff ff 00 00 f0 0f c1=20



Cheers,
	Bernd

--=20
Bernd Schubert
Physikalisch Chemisches Institut / Theoretische Chemie
Universit=E4t Heidelberg
INF 229
69120 Heidelberg
e-mail: bernd.schubert@pci.uni-heidelberg.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
