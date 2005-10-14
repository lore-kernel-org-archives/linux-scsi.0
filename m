From: Roger While <simrw@sim-basis.de>
Subject: 2.6 megaraid_mbox MSI
Date: Fri, 14 Oct 2005 08:28:40 +0200
Message-ID: <6.1.1.1.2.20051014082527.026aba58@192.168.6.2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout08.sul.t-online.com ([194.25.134.20]:31189 "EHLO
	mailout08.sul.t-online.com") by vger.kernel.org with ESMTP
	id S932214AbVJNG3m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 02:29:42 -0400
Received: from simrog.sim-basis.de [192.168.6.50]
	by sim-basis.de [192.168.6.2]
	with SMTP (MDaemon.PRO.v5.0.4.R)
	for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2005 08:31:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Any reason the megaraid driver is not using MSI ?

eg. On a Dell system, the Perc is MSI capable -

Subsystem: Dell PowerEdge Expandable RAID Controller 4e/Di
Flags: bus master, stepping, 66Mhz, medium devsel, latency 64, IRQ 193
Memory at f80f0000 (32-bit, prefetchable) [size=64K]
Memory at fe9c0000 (32-bit, non-prefetchable) [size=256K]
Expansion ROM at fea00000 [disabled] [size=128K]
Capabilities: [c0] Power Management version 2
Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
Capabilities: [e0] PCI-X non-bridge device

Roger While



