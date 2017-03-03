From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 188061] On quad port QLE2564 can't add in target only 2 ports
Date: Fri, 03 Mar 2017 07:37:08 +0000
Message-ID: <bug-188061-11613-yEZJ40IPnX@https.bugzilla.kernel.org/>
References: <bug-188061-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51178 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751143AbdCCHiY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2017 02:38:24 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id D084E27CAF
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2017 07:37:08 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8C61227BFF
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2017 07:37:08 +0000 (UTC)
In-Reply-To: <bug-188061-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188061

--- Comment #5 from Anthony (anthony.bloodoff@gmail.com) ---
I've installed another 4-port card and got same issue - port names have
variable part at highest bits. On 2-port card port names have variable part at
lower bits:
    port_name           = "0x21000024ff3bcb3e"
    port_name           = "0x21000024ff3bcb3f"
I'm trying to change a port name in NVRAM with FLASUTIL.EXE with no luck.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
