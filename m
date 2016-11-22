From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 179341] mpt3sas: LSISAS3008 don't see Intel 540s SSD
Date: Tue, 22 Nov 2016 10:46:57 +0000
Message-ID: <bug-179341-11613-OY8Vb1mKsj@https.bugzilla.kernel.org/>
References: <bug-179341-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932263AbcKVKrC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Nov 2016 05:47:02 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id B360020122
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2016 10:47:00 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 98F7120272
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2016 10:46:57 +0000 (UTC)
In-Reply-To: <bug-179341-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=179341

Chaitra P B <chaitra.basappa@broadcom.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |chaitra.basappa@broadcom.co
                   |                            |m

--- Comment #6 from Chaitra P B <chaitra.basappa@broadcom.com> ---
Badalyan,
 From attached driver logs, I could see FW is issuing internal device reset
many times for the drive with handle (0x0009) and also Inquiry command for this
particular drive is getting terminated.

There are many reasons for which Fimware sends internal device reset. 
And hence we need Firmware logs to find out reason for internal device reset,
also Inquiry command is getting terminated because it is issued during device
reset is in progress.

Please share Firmware logs to debug/analyse this issue further.

-- 
You are receiving this mail because:
You are watching someone on the CC list of the bug.
