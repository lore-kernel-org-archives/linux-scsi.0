From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 98171] [Regression] Marvell SE91xx SATA 3 controllers not
 recognized correctly
Date: Tue, 19 Jan 2016 14:33:15 +0000
Message-ID: <bug-98171-11613-JMOApdD51k@https.bugzilla.kernel.org/>
References: <bug-98171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39546 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602AbcASOdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2016 09:33:19 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id F34912043C
	for <linux-scsi@vger.kernel.org>; Tue, 19 Jan 2016 14:33:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 08A3620452
	for <linux-scsi@vger.kernel.org>; Tue, 19 Jan 2016 14:33:17 +0000 (UTC)
In-Reply-To: <bug-98171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D98171

J=C3=BCrgen H=C3=B6rmann <info@juergenhoermann.de> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
                 CC|                            |info@juergenhoermann.d=
e

--- Comment #5 from J=C3=BCrgen H=C3=B6rmann <info@juergenhoermann.de> =
---
Having this issue too.
My apt database got corrupted while installing update packages.

[    2.232046] ata14.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0=
x6
[    2.232054] ata14.00: irq_stat 0x40000001
[    2.232067] ata14.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 2 =
dma
16640 in
                        Inquiry 12 01 00 00 ff 00res
00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x3 (HSM violation)


My System: Ubuntu 15.10 64bit
Kernel: 4.2.0-23-generic

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
