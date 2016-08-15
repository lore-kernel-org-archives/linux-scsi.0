From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3805 prints "AAC: Host adapter dead -1" every
 10 seconds but works fine anyway
Date: Mon, 15 Aug 2016 07:17:01 +0000
Message-ID: <bug-151661-11613-r7tdCw0WPF@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44338 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbcHOHRG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2016 03:17:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2E541201B9
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2016 07:17:05 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B4E7A201C7
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2016 07:17:01 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

Harold Snel <harold@snel.ws> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |harold@snel.ws

--- Comment #7 from Harold Snel <harold@snel.ws> ---
I have the exact same issue on my server running with an Adaptec 3405. The root
system is mounted on that controller on an SSD harddisk. Until I upgraded from
14.04 TLS to 16.04 TLS it was working fine.

After I upgraded to an new kernel first (from 4.2.0-41 to 4.2.0-42) the issue
with the 'dead adapter' started. To test if a full system upgrade to 16.04 TLS
would help I upgrade the system to that release. But on that version the
problem is still there and the system is not usable.

Now I'm running on 16.04 TLS but with the older kernel (4.2.0-41) and thats
working just fine. But I want to use the newest kernel because thats how it
should be :-)

Here is some controller info:
===
root@server:~# lspci -nnvs 03:0e.0
03:0e.0 RAID bus controller [0104]: Adaptec AAC-RAID [9005:0285]
         Subsystem: Adaptec 3405 [9005:02bb]
         Flags: bus master, stepping, 66MHz, medium devsel, latency 64, 
IRQ 18
         Memory at fda00000 (64-bit, non-prefetchable) [size=2M]
         Expansion ROM at fdcc0000 [disabled] [size=256K]
         Capabilities: [c0] Power Management version 2
         Capabilities: [d0] MSI: Enable- Count=1/2 Maskable- 64bit+
         Capabilities: [e0] PCI-X non-bridge device
         Kernel driver in use: aacraid
         Kernel modules: aacraid
===

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
