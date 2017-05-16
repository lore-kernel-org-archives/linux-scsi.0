From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195285] qla2xxx FW immediatly crashing after target start
Date: Tue, 16 May 2017 14:45:22 +0000
Message-ID: <bug-195285-11613-EXHeQ6hjo0@https.bugzilla.kernel.org/>
References: <bug-195285-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:45782 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750777AbdEPOpZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 May 2017 10:45:25 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7090B28A41
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2017 14:45:24 +0000 (UTC)
In-Reply-To: <bug-195285-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=195285

--- Comment #4 from Anthony (anthony.bloodoff@gmail.com) ---
I'm trying to select working setting, and some investigation shows:
with parameter ql2xmqsupport=0 - target starting to work

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
