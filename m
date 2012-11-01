From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 49821] Random Call traces when using tape device.
Date: Thu,  1 Nov 2012 14:12:42 +0000 (UTC)
Message-ID: <20121101141242.B643211FB91@bugzilla.kernel.org>
References: <bug-49821-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49549 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756011Ab2KAOMp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Nov 2012 10:12:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A3239203C2
	for <linux-scsi@vger.kernel.org>; Thu,  1 Nov 2012 14:12:44 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 9B755203BC
	for <linux-scsi@vger.kernel.org>; Thu,  1 Nov 2012 14:12:43 +0000 (UTC)
In-Reply-To: <bug-49821-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=49821


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk




--- Comment #1 from Alan <alan@lxorguk.ukuu.org.uk>  2012-11-01 14:12:42 ---
nvidia              10188726  41 

Please verify you can duplicate this without proprietary stuff loaded. In this
case I expect you can but it would be good to check.


[    8.737551] scsi8 : ioc0: LSI53C1030 B2, FwRev=01032700h, Ports=1, MaxQ=255,
IRQ=17

does look like an unhandled interrupt from the device

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
