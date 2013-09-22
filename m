From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Sun, 22 Sep 2013 21:01:16 +0000
Message-ID: <bug-60758-11613-URF2kPcL5Q@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49356 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab3IVVBT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Sep 2013 17:01:19 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AF9CD2052F
	for <linux-scsi@vger.kernel.org>; Sun, 22 Sep 2013 21:01:18 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id F2279204C7
	for <linux-scsi@vger.kernel.org>; Sun, 22 Sep 2013 21:01:16 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #33 from zakrzewskim@wp.pl ---
Maybe this will help:

lspci
00:00.0 Host bridge: Intel Corporation 4th Gen Core Processor DRAM Controller
(rev 06)
00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v3/4th Gen
Core Processor Integrated Graphics Controller (rev 06)
00:03.0 Audio device: Intel Corporation Xeon E3-1200 v3/4th Gen Core Processor
HD Audio Controller (rev 06)
00:14.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset Family
USB xHCI (rev 04)
00:16.0 Communication controller: Intel Corporation 8 Series/C220 Series
Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset Family
USB EHCI #2 (rev 04)
00:1c.0 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset Family PCI
Express Root Port #1 (rev d4)
00:1c.1 PCI bridge: Intel Corporation 8 Series/C220 Series Chipset Family PCI
Express Root Port #2 (rev d4)
00:1c.3 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d4)
00:1d.0 USB controller: Intel Corporation 8 Series/C220 Series Chipset Family
USB EHCI #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation H87 Express Chipset LPC Controller (rev
04)
00:1f.2 SATA controller: Intel Corporation 8 Series/C220 Series Chipset Family
6-port SATA Controller 1 [AHCI mode] (rev 04)
00:1f.3 SMBus: Intel Corporation 8 Series/C220 Series Chipset Family SMBus
Controller (rev 04)
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI
Express Gigabit Ethernet controller (rev 06)
03:00.0 PCI bridge: ASMedia Technology Inc. ASM1083/1085 PCIe to PCI Bridge
(rev 03)

-- 
You are receiving this mail because:
You are the assignee for the bug.
