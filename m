From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194837] VM with virtio-scsi drive often crashes during boot
 with kernel 4.11rc1
Date: Tue, 14 Mar 2017 21:23:49 +0000
Message-ID: <bug-194837-11613-HnyFg10JC2@https.bugzilla.kernel.org/>
References: <bug-194837-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:47290 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751082AbdCNVY0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Mar 2017 17:24:26 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id BC92026E81
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 21:23:54 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4C22C285CF
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 21:23:53 +0000 (UTC)
In-Reply-To: <bug-194837-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194837

--- Comment #7 from Thorsten Leemhuis (regressions@leemhuis.info) ---
Leaving the keyboard now; I'm down to 1827adb11ad2...590dce2d4934 (includes
e0d072250a54669dce876d8ade70e417356aae74 Merge branch 'for-linus' of
git://git.kernel.dk/linux-block )

-- 
You are receiving this mail because:
You are the assignee for the bug.
