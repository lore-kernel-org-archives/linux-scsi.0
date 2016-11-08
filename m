From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151631] "Synchronizing SCSI cache" fails during(and delays)
 reboot/shutdown
Date: Tue, 08 Nov 2016 08:11:27 +0000
Message-ID: <bug-151631-11613-mgFurC4C17@https.bugzilla.kernel.org/>
References: <bug-151631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751998AbcKHILa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Nov 2016 03:11:30 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 798172026D
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2016 08:11:28 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 782A82026C
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2016 08:11:27 +0000 (UTC)
In-Reply-To: <bug-151631-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151631

Gianpaolo <gianpaoloc@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |gianpaoloc@gmail.com

--- Comment #5 from Gianpaolo <gianpaoloc@gmail.com> ---
Created attachment 243891
  --> https://bugzilla.kernel.org/attachment.cgi?id=243891&action=edit
Patch reverting commit 2c85025c75dfe7ddc2bb33363a998dad59383f94

This patch solved bug https://bugzilla.kernel.org/show_bug.cgi?id=187061 which
I suspect being a duuplicate of this bug. If someone affected by this bug could
test it and confirm it works (it should work both with v4.8.6 and v4.9-rc4).

-- 
You are receiving this mail because:
You are the assignee for the bug.
