From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 191471] Mp2Sas and Mpt3Sas (now mpxsas) drivers are spinning
 forever in the IRQ handler under load condition
Date: Mon, 03 Apr 2017 15:31:37 +0000
Message-ID: <bug-191471-11613-cSHbayEnWU@https.bugzilla.kernel.org/>
References: <bug-191471-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:43940 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753803AbdDCPbl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2017 11:31:41 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 367002846F
        for <linux-scsi@vger.kernel.org>; Mon,  3 Apr 2017 15:31:41 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 0B94A28429
        for <linux-scsi@vger.kernel.org>; Mon,  3 Apr 2017 15:31:41 +0000 (UTC)
In-Reply-To: <bug-191471-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=191471

Timur Tabi (timur@codeaurora.org) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |timur@codeaurora.org

--- Comment #1 from Timur Tabi (timur@codeaurora.org) ---
Created attachment 255737
  --> https://bugzilla.kernel.org/attachment.cgi?id=255737&action=edit
Propsed fix

-- 
You are receiving this mail because:
You are the assignee for the bug.
