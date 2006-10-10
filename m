From: Csillag Tamas <cstamas@digitus.itk.ppke.hu>
Subject: megaraid not working in 2.6.18
Date: Tue, 10 Oct 2006 11:07:29 +0200
Message-ID: <20061010090729.GD905@digitus>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jugis.itk.ppke.hu ([193.225.109.42]:8421 "EHLO
	jugis.itk.ppke.hu") by vger.kernel.org with ESMTP id S965114AbWJJJHi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 05:07:38 -0400
Received: from jugis (jugis [127.0.0.1])
	by checked.jugis.itk.ppke.hu (Postfix) with ESMTP id D6538B5F
	for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2006 11:07:37 +0200 (CEST)
Received: from rivendell.itk.ppke.hu (rivendell.itk.ppke.hu [193.225.109.193])
	by jugis.itk.ppke.hu (Postfix) with ESMTP id F3943AE5
	for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2006 11:07:31 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline

hi,

I have two servers with AMI megaraid.
They both runnig 2.6.11.*

I want to upgrade to 2.6.18. The problem is: the driver does not work
anymore.

If I try the new driver, the kernel freezes after I see a stack trace
dump. It is OK, I read somewhere that I should not use this new one as
it does not support my old cards.

However the legacy megaraid drivers does not work either. I get
unknown-block-device error when the kernel tries to mount sdaX.
I do not even see the megaraid driver coming up! no detecting messages like
in 2.6.11

This page: http://linux.dell.com/storage.shtml#megaraid lead me to this
list.

# lspci -v
0000:00:00.0 Host bridge: ServerWorks CNB20LE Host Bridge (rev 06)
        Flags: bus master, medium devsel, latency 48

0000:00:00.1 Host bridge: ServerWorks CNB20LE Host Bridge (rev 06)
        Flags: bus master, medium devsel, latency 32

0000:00:02.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] (rev 0d)
        Subsystem: Hewlett-Packard Company NetServer 10/100TX
        Flags: bus master, medium devsel, latency 64, IRQ 10
        Memory at fd020000 (32-bit, non-prefetchable) [size=4K]
        I/O ports at 1800 [size=64]
        Memory at fd000000 (32-bit, non-prefetchable) [size=128K]
        Capabilities: [dc] Power Management version 2

0000:00:04.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] (rev 08)
        Subsystem: Hewlett-Packard Company NetServer 10/100TX
        Flags: bus master, medium devsel, latency 64, IRQ 5
        Memory at fd021000 (32-bit, non-prefetchable) [size=4K]
        I/O ports at 1840 [size=64]
        Memory at fd100000 (32-bit, non-prefetchable) [size=1M]
        Capabilities: [dc] Power Management version 2

0000:00:06.0 RAID bus controller: American Megatrends Inc. MegaRAID (rev 20)
        Subsystem: Hewlett-Packard Company: Unknown device 60e7
        Flags: bus master, medium devsel, latency 64, IRQ 11
        Memory at fd400000 (32-bit, prefetchable) [size=64K]
        Capabilities: [80] Power Management version 2

0000:00:07.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27) (prog-if 00 [VGA])
        Subsystem: Hewlett-Packard Company: Unknown device 10e1
        Flags: bus master, stepping, medium devsel, latency 66, IRQ 11
        Memory at fc000000 (32-bit, non-prefetchable) [size=16M]
        I/O ports at 1400 [size=256]
        Memory at fd022000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [5c] Power Management version 2

0000:00:0f.0 Host bridge: ServerWorks CSB5 South Bridge (rev 93)
        Subsystem: Hewlett-Packard Company: Unknown device 129b
        Flags: bus master, medium devsel, latency 32

0000:00:0f.1 IDE interface: ServerWorks CSB5 IDE Controller (rev 93) (prog-if 8a [Master SecP PriP])
        Subsystem: Hewlett-Packard Company: Unknown device 129b
        Flags: bus master, medium devsel, latency 32
        I/O ports at <ignored>
        I/O ports at <ignored>
        I/O ports at <ignored>
        I/O ports at <ignored>
        I/O ports at 1880 [size=16]

0000:00:0f.2 USB Controller: ServerWorks OSB4/CSB5 OHCI USB Controller (rev 05) (prog-if 10 [OHCI])
        Subsystem: Hewlett-Packard Company: Unknown device 129b
        Flags: medium devsel, IRQ 11
        Memory at fd023000 (32-bit, non-prefetchable) [size=4K]

0000:00:0f.3 ISA bridge: ServerWorks CSB5 LPC bridge
        Subsystem: Hewlett-Packard Company: Unknown device 129b
        Flags: bus master, medium devsel, latency 0

0000:05:04.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 66MHz  Ultra3 SCSI Adapter (rev 01)
        Subsystem: Hewlett-Packard Company: Unknown device 60a0
        Flags: bus master, 66MHz, medium devsel, latency 72, IRQ 9
        I/O ports at 1c00 [size=256]
        Memory at fd412000 (64-bit, non-prefetchable) [size=1K]
        Memory at fd410000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: [40] Power Management version 2

0000:05:04.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 66MHz  Ultra3 SCSI Adapter (rev 01)
        Subsystem: Hewlett-Packard Company: Unknown device 60a0
        Flags: bus master, 66MHz, medium devsel, latency 72, IRQ 11
        I/O ports at 2000 [size=256]
        Memory at fd412400 (64-bit, non-prefetchable) [size=1K]
        Memory at fd414000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: [40] Power Management version 2

I attach my kernel config file too (for 2.6.18).

Thanks in advance. Ask for more info if needed.
please cc to me.
-- 

CSILLAG Tamas (cstamas) - http://digitus.itk.ppke.hu/~cstamas

--d6Gm4EdcadzBjdND
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="config.gz"
Content-Transfer-Encoding: base64

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
V5zThV8q80lC4Dj4P7R7v6szigAA

--d6Gm4EdcadzBjdND--
