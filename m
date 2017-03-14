From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 194837] VM with virtio-scsi drive often crashes during boot
 with kernel 4.11rc1
Date: Tue, 14 Mar 2017 22:56:29 +0000
Message-ID: <bug-194837-11613-oPMBAEPLa1@https.bugzilla.kernel.org/>
References: <bug-194837-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:51938 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751131AbdCNW4j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Mar 2017 18:56:39 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5F94F285EB
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 22:56:38 +0000 (UTC)
Received: from pdx-korg-bugzilla-1.web.codeaurora.org (unknown [172.30.200.120])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B7B7B285EB
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 22:56:37 +0000 (UTC)
In-Reply-To: <bug-194837-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=194837

Omar Sandoval (osandov@osandov.com) changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |osandov@osandov.com

--- Comment #8 from Omar Sandoval (osandov@osandov.com) ---
This was fixed in v4.11-rc2.

-- 
You are receiving this mail because:
You are the assignee for the bug.
