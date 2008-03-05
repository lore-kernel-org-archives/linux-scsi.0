From: "Rodrigo Severo" <rodrigo@fabricadeideias.com>
Subject: Adaptec 29320LPE errors on boot
Date: Wed, 5 Mar 2008 12:42:04 -0300
Message-ID: <a7108f870803050742x6a960bf4sed894208a5fb3931@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.230]:32737 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYCEPmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 10:42:07 -0500
Received: by wx-out-0506.google.com with SMTP id h31so1973205wxd.4
        for <linux-scsi@vger.kernel.org>; Wed, 05 Mar 2008 07:42:06 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,


I have this Adaptec 29320LPE SCSI board (used the aic79xx driver)
which give several errors during boot time, just after it recognizes
the HDs connected to it.

If I remove the SCSI HD there are no SCSI errors.

The very first error messages have scrolled up and I don't know how to
get to them (is there a way?) but here is the transcript of what I can
see:

scsi0: hwerrint, Sequencer Parity Error
scsi0: hwerrint, Data-path Parity Error
scsi0: hwerrint, Scratch or SCB Memory Parity Error
scsi0: hwerrint, CIOBUS Parity Error
>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0xffff Mode 0x77
Card was paused
INTSTAT[0xff] SELOID[0xff] SELID[0xff] HS_MAILBOX[0xff]
INTCTL[0xff] SEQINTSTAT[0xff] SAVED_MODE[0xff]
DFFSTAT[0xff] SCSISIGI[0xff] SCSIPHASE[0xff] SCSIBUS[0xff]
LASTPHASE[0xff] SCSISEQ0[0xff] SCSISEQ1[0xff] SEQCTL0[0xff]
SEQINTCTL[0xff] SEQ_FLAGS[0xff] SEQ_FLAGS2[0xff]
QFREEZE_COUNT[0xffff] KERNEL_QFREEZE_COUNT[0xffff]
MK_MESSAGE_SCB[0xffff] MK_MESSAGE_SCSIID[0xff]
SSTAT0[0xff] SSTAT1[0xff] SSTAT2[0xff] SSTAT3[0xff]
PERRDIAG[0xff] SIMODE1[0xff] LQISTAT0[0xff] LQISTAT1[0xff]
LQSTAT2[0xff] LQOSTAT0[0xff] LQOSTAT1[0xff] LQOSTAT2[0xff]

SCB Count =3D 4 CMDS_PENDING =3D 65535 LASTSCB 0xffff CURRSCB 0xffff NE=
XTSCB 0xffff
CPU 0: Machine Check Exception: 0000000000000004
CPU 0: BAnk 4: 3200000000070f0f
Kernel panic - not syncing: CPU context corrupt

Some extra info on the machine:

# cat /proc/version
Linux version 2.6.25-rc4 (root@lab) (gcc version 4.1.2 (Gentoo 4.1.2
p1.0.2)) #3 Wed Mar 5 12:21:22 BRT 2008

# lspci
00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
00:02.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
00:03.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
00:04.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
00:05.0 VGA compatible controller: nVidia Corporation C51G [GeForce
6100] (rev a2)
00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
00:0a.0 ISA bridge: nVidia Corporation MCP51 LPC Bridge (rev a2)
00:0a.1 SMBus: nVidia Corporation MCP51 SMBus (rev a2)
00:0a.2 RAM memory: nVidia Corporation MCP51 Memory Controller 0 (rev a=
2)
00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a2=
)
00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev a2=
)
00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev a1)
00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2)
00:10.2 Multimedia audio controller: nVidia Corporation MCP51 AC97
Audio Controller (rev a2)
00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a1)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
02:00.0 PCI bridge: PLX Technology, Inc. PEX 8114 PCI
Express-to-PCI/PCI-X Bridge (rev bc)
03:04.0 SCSI storage controller: Adaptec ASC-29320ALP U320 (rev 10)

Please let me know if there is any extra info needed. I can make any
modifications necessary as this is a test machine.


TIA,

Rodrigo Severo

--=20
-----------------------------------------------------------------------=
----------------
Rodrigo Severo

=46=E1brica de Id=E9ias
SBS Quadra 2 - Bloco S - Ed. Empire Center - Sala 1.301
Bras=EDlia - DF - CEP 70070-904
Tel. (61) 3321-1357       Fax (61) 3223-1712
-----------------------------------------------------------------------=
----------------
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
