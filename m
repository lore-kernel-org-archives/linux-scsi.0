From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3405 3805 prints "AAC: Host adapter dead -1"
 every 10 seconds but works fine anyway
Date: Wed, 21 Jun 2017 22:43:54 +0000
Message-ID: <bug-151661-11613-FvMIZ5dwhx@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:52840 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752020AbdFUWoH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 18:44:07 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 2FC2E2846D
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:44:06 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

--- Comment #20 from Stuart Naifeh (scnaifeh@hotmail.com) ---
As of June 21, 2017, I am still seeing this in Debian Stretch running kernel
4.10.0-rc6.  I have an IBM ServeRaid 8s, which is a rebranded Adaptec 4805.  I
see the message repeat about every second, so it really fills up syslog
quickly.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
