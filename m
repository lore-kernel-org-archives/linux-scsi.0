From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 198161] incremental patch-4.9.51-52 on sg.c break Nero 4 nero
 burning rom application
Date: Thu, 14 Dec 2017 09:24:09 +0000
Message-ID: <bug-198161-11613-7RAjaAQ8J0@https.bugzilla.kernel.org/>
References: <bug-198161-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:48234 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751462AbdLNJYL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Dec 2017 04:24:11 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 9F4C929BF8
        for <linux-scsi@vger.kernel.org>; Thu, 14 Dec 2017 09:24:10 +0000 (UTC)
In-Reply-To: <bug-198161-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=198161

Johannes Thumshirn (jthumshirn@suse.de) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jthumshirn@suse.de

--- Comment #2 from Johannes Thumshirn (jthumshirn@suse.de) ---
(In reply to Jean-Luc from comment #0)
> Hi
> 
> Nero 4 Linux can no longer detect devices since the changes in code in sg.c.
> It displays the following message: "Warning: no device detected"...
> 
> Regards

Can you please re-test with a more recent kernel (e.g. v4.14) ? I have had
submitted a fix for exactly this issue with Nero and believe it is gone.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
