From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Sun, 19 Feb 2017 11:55:58 +0000
Message-ID: <bug-60644-11613-AzpyRZJ6tt@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:49282 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751327AbdBSL4A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Feb 2017 06:56:00 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 229B428797
        for <linux-scsi@vger.kernel.org>; Sun, 19 Feb 2017 11:56:00 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 17151287AD
        for <linux-scsi@vger.kernel.org>; Sun, 19 Feb 2017 11:55:59 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #52 from ojab@ojab.ru ---
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=ffdadd68af5a397b8a52289ab39d62e1acb39e63

Patch is merged, bug can be closed.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
