From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 175431] scsi host6: runtime PM trying to activate child device
 host6 but parent (3-1:1.0) is not active
Date: Sun, 02 Oct 2016 22:45:16 +0000
Message-ID: <bug-175431-11613-COsbx9bNzf@https.bugzilla.kernel.org/>
References: <bug-175431-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751130AbcJBWpV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 2 Oct 2016 18:45:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 7583F2024D
        for <linux-scsi@vger.kernel.org>; Sun,  2 Oct 2016 22:45:19 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 797FA201EF
        for <linux-scsi@vger.kernel.org>; Sun,  2 Oct 2016 22:45:17 +0000 (UTC)
In-Reply-To: <bug-175431-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=175431

Cristian Aravena Romero <caravena@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |DUPLICATE

--- Comment #1 from Cristian Aravena Romero <caravena@gmail.com> ---


*** This bug has been marked as a duplicate of bug 153171 ***

-- 
You are receiving this mail because:
You are the assignee for the bug.
