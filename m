From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 188061] On quad port QLE2564 can't add in target only 2 ports
Date: Fri, 03 Mar 2017 17:42:34 +0000
Message-ID: <bug-188061-11613-QjgvwMecCk@https.bugzilla.kernel.org/>
References: <bug-188061-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54156 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751641AbdCCRwE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2017 12:52:04 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id E275C285D8
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2017 17:42:40 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id ADBF9285D4
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2017 17:42:40 +0000 (UTC)
In-Reply-To: <bug-188061-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188061

--- Comment #6 from himanshu.madhani@cavium.com (himanshu.madhani@qlogic.com) ---
(In reply to Anthony from comment #5)
> I've installed another 4-port card and got same issue - port names have
> variable part at highest bits. On 2-port card port names have variable part
> at lower bits:
>     port_name           = "0x21000024ff3bcb3e"
>     port_name           = "0x21000024ff3bcb3f"
> I'm trying to change a port name in NVRAM with FLASUTIL.EXE with no luck.

Hi Anthony, 

Can you please attach output of following command from your 4-port card.

# lspci -vvv -s <pci_bus_for_each_port>

So for example 

# lspci -vvv -s 09.00.0 and so on for each of the 4 ports of 4-port card. 

Thanks,
Himanshu

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
