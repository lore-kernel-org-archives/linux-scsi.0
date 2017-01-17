From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151631] "Synchronizing SCSI cache" fails during(and delays)
 reboot/shutdown
Date: Tue, 17 Jan 2017 20:56:20 +0000
Message-ID: <bug-151631-11613-z9spxBle5V@https.bugzilla.kernel.org/>
References: <bug-151631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750929AbdAQU5P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Jan 2017 15:57:15 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 53DA620462
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2017 20:56:22 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 6025A2043C
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2017 20:56:20 +0000 (UTC)
In-Reply-To: <bug-151631-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151631

--- Comment #10 from Vyacheslav Dikonov <sdiconov@mail.ru> ---
One further observation. The drive was attached to an USB2 controller 

00:1d.0 USB controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
USB UHCI Controller

through an USB hub, which has  both USB2 and USB3 ports. The bug occurs when I
try to reattach the hdd to the same type of ports. The HDD works when I change
the type of ports (USB2 > USB3 or USB3 > USB2). It happens again if I do not
change the type of connection. It might be a different USB-related problem, but
the error message is the same "Synchronize Cache(10) failed"

-- 
You are receiving this mail because:
You are the assignee for the bug.
