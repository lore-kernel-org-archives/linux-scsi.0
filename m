From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187381] 4.9.-rc4 produces hundreds of unusable scsi devices.
Date: Thu, 10 Nov 2016 13:15:47 +0000
Message-ID: <bug-187381-11613-uSzJSZltUO@https.bugzilla.kernel.org/>
References: <bug-187381-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932336AbcKJNPv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Nov 2016 08:15:51 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 3057A203DF
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2016 13:15:49 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 46FF3203B1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2016 13:15:48 +0000 (UTC)
In-Reply-To: <bug-187381-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=187381

Tommy Wu <wu.tommy@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |wu.tommy@gmail.com

--- Comment #4 from Tommy Wu <wu.tommy@gmail.com> ---
I got same issue today.
After apply the patch, everything work fine now.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
