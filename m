From: Ralph Bergmann <ralph@dasralph.de>
Subject: 2.6.6 Kernel + Adaptec aic7890/91 = Kernel panic
Date: Sun, 06 Jun 2004 13:55:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40C30644.2020307@dasralph.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout09.sul.t-online.com ([194.25.134.84]:65474 "EHLO
	mailout09.sul.t-online.com") by vger.kernel.org with ESMTP
	id S263338AbUFFLza (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Jun 2004 07:55:30 -0400
Received: from localhost ([127.0.0.1] ident=amavis)
	by linuxserver.dasralph.de with esmtp (Exim 4.32)
	id 1BWwFF-0002ZD-FT
	for linux-scsi@vger.kernel.org; Sun, 06 Jun 2004 13:55:21 +0200
Received: from linuxserver.dasralph.de ([127.0.0.1])
	by localhost (linuxserver [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 09819-04 for <linux-scsi@vger.kernel.org>;
	Sun, 6 Jun 2004 13:55:20 +0200 (CEST)
Received: from win2k.dasralph.de ([192.168.1.10])
	by linuxserver.dasralph.de with esmtp (Exim 4.32)
	id 1BWwFE-0002Z8-MH
	for linux-scsi@vger.kernel.org; Sun, 06 Jun 2004 13:55:20 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello!

If I use the 2.6.6 kernel, I get a "Kernel panic" when starting.

I use a Debian unstable, last update 31.Mai 2004.

Kernel:
kernel-image-2.6.6-1-686-smp

System:
0000:00:00.0 Host bridge: ServerWorks CNB20LE Host Bridge (rev 05)
0000:00:00.1 Host bridge: ServerWorks CNB20LE Host Bridge (rev 05)
0000:00:01.0 PCI bridge: Hint Corp HB6 Universal PCI-PCI bridge 
(non-transparent mode) (rev 13)
0000:00:04.0 Multimedia audio controller: Ensoniq ES1370 [AudioPCI] (rev 01)
0000:00:06.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 
100] (rev 08)
0000:00:0f.0 ISA bridge: ServerWorks OSB4 South Bridge (rev 4f)
0000:00:0f.1 IDE interface: ServerWorks OSB4 IDE Controller
0000:00:0f.2 USB Controller: ServerWorks OSB4/CSB5 OHCI USB Controller 
(rev 04)
0000:01:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA G400 
AGP (rev 85)
0000:02:01.0 SCSI storage controller: Adaptec AHA-2940U2/U2W

Error-Message:
SCSI subsystem initialized
FATAL: Error inserting aic7xxx 
(/lib/modules/2.6.6-1-686-smp/kernel/drivers/scsi/aic7xxx/aic7xxx.ko) Nu 
such device
pivot_root: No such file or directory
/sbin/init: 424: cannot open dev/console: No such file
Kernel panic: Attempted to kill init!

The kernel-image-2.4.25-1-686-smp works fine.

Does someone have an idea?

Ralph

