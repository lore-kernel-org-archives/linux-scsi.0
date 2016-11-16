From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187231] kernel panic during hpsa MSI plus tg3 MSI
Date: Wed, 16 Nov 2016 06:17:38 +0000
Message-ID: <bug-187231-11613-m0bLdqMVST@https.bugzilla.kernel.org/>
References: <bug-187231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752170AbcKPGRn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Nov 2016 01:17:43 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 2F007203C2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2016 06:17:41 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id A7360203B8
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2016 06:17:38 +0000 (UTC)
In-Reply-To: <bug-187231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=187231

Patrick Schaaf <kernelorg@bof.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |UNREPRODUCIBLE

--- Comment #6 from Patrick Schaaf <kernelorg@bof.de> ---
After several more such Abort request / reset sequences with 3.14.79, two days
ago the box _finally_ announced that one of its 8 drives has a SMART
"predictive failure"; after swapping that drive for a spare, the symptoms are
no longer seen.

This is the third or fourth time, over the last year, that I've seen Gen9
servers with P440ar cards behave that way.

Anyway, my immediate test case is gone, so I'll close this as RESOLVED /
unreproducible...

-- 
You are receiving this mail because:
You are the assignee for the bug.
