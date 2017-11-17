From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 197877] arcmsr fails to initialize Areca ARC-1110/ARC-1120 on
 some systems
Date: Fri, 17 Nov 2017 19:39:47 +0000
Message-ID: <bug-197877-11613-fUbTG0Qduv@https.bugzilla.kernel.org/>
References: <bug-197877-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42842 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751102AbdKQTju (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Nov 2017 14:39:50 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 97FE12A802
        for <linux-scsi@vger.kernel.org>; Fri, 17 Nov 2017 19:39:49 +0000 (UTC)
In-Reply-To: <bug-197877-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=197877

--- Comment #4 from kr@sognnes.no ---
Building the latest Areca driver (1.40.00.02 from
http://www.areca.us/support/s_linux/driver/Source%20Code/arcmsr-1.40.00.02-source-only.dkms.tar.gz)
against kernel 3.17.8 introduces the bug, so it's definitely the driver rather
than some other issue with the kernel.

The latest driver that works on the affected systems seems to be
1.20.0X.15-130619
(ftp://ftp.areca.com.tw/RaidCards/AP_Drivers/Linux/DRIVER/SourceCode/arcmsr.1.20.0X.15-130619.zip),
which unfortunately doesn't compile against recent kernels.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
