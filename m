From: Agri <agri@desnol.ru>
Subject: scsi and dma
Date: Mon, 17 Nov 2003 06:17:47 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031117061747.6cb07084.agri@desnol.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from desnol.ru ([217.150.58.74]:19717 "EHLO desnol.ru")
	by vger.kernel.org with ESMTP id S263294AbTKQDRt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Nov 2003 22:17:49 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, ipslinux@adaptec.com

Hello

RAID bus controller: IBM Netfinity ServeRAID controller (ips.o driver)
is installed in my box.

I have trouble with high cpu load during io operations.
Also sound playing delays and breaks during io with that controller.

How to fix it?

Linux version 2.4.23-rc1


06:08:19#/> lspci -s 00:11.0 -v
00:11.0 RAID bus controller: IBM Netfinity ServeRAID controller
        Subsystem: IBM: Unknown device 020e
        Flags: bus master, 66Mhz, slow devsel, latency 32, IRQ 11
        Memory at d9400000 (32-bit, prefetchable) [size=8K]
        Expansion ROM at <unassigned> [disabled] [size=32K]
        Capabilities: [80] Power Management version 2


06:16:48#/> cat /proc/scsi/ips/1 

IBM ServeRAID General Information:

        Controller Type                   : ServeRAID 4Lx
        Memory region                     : 0xd9400000 (8192 bytes)
        Shared memory address             : 0xd0a76000
        IRQ number                        : 11
        BIOS Version                      : 4.84.01
        Firmware Version                  : 4.84.01
        Boot Block Version                : 4.84.01
        Driver Version                    : 6.10.24 
        Driver Build                      : 1250
        Max Physical Devices              : 15
        Max Active Commands               : 32
        Current Queued Commands           : 0
        Current Active Commands           : 0
        Current Queued PT Commands        : 0
        Current Active PT Commands        : 0


Agri

