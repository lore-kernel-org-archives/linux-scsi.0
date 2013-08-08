From: Sasikanth babu <sasikanth.v19@gmail.com>
Subject: mvumi driver
Date: Thu, 8 Aug 2013 12:46:28 +0530
Message-ID: <CAOJFanVjjmZWVi1CEoszDBgfUujboFZuT1o1PT0YwTOYezoYWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:37196 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab3HHHQ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2013 03:16:29 -0400
Received: by mail-oa0-f49.google.com with SMTP id n10so2708985oag.36
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2013 00:16:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 I have a two Marvel Sata Marvell 88NV9143 controller disks on the
board. When I tried to load mvumi module
 I'm getting an invalid signature error. Further debugging I found any
read on memory mapped IO returns 0xffffffff (-1).
 And also the PCI bar address is 64bit where as device is 32-bit


 [CPU] ->  [IDT PCI-E Interconnet Switch]  -> [MVUMI controller, SATA1 & SATA2]

mvumi 0000:03:00.1: invalid signature [0xffffffff].
mvumi: probe of 0000:03:00.1 failed with error -22

 Kernel : 2.6.34.12 Longterm
Arch   : mips/octeon

03:00.1 Mass storage controller: Device 1b4b:9143 (rev 11)
        Subsystem: Device 1b4b:9143
        Flags: bus master, fast devsel, latency 0, IRQ 129
        Memory at 11c0112000000 (32-bit, prefetchable) [size=1M]
        [virtual] Expansion ROM at 11c0112110000 [disabled] [size=64K]
        Capabilities: [50] Power Management version 3

 cat /proc/iomem
   11c0112000000-11c01120fffff : mvumi

Thanks in advance
