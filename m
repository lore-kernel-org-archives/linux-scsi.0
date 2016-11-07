From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187231] kernel panic during hpsa MSI plus tg3 MSI
Date: Mon, 07 Nov 2016 15:45:01 +0000
Message-ID: <bug-187231-11613-M3E4vWdMBk@https.bugzilla.kernel.org/>
References: <bug-187231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752312AbcKGPpG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Nov 2016 10:45:06 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id AC7282025A
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2016 15:45:04 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id E960420218
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2016 15:45:01 +0000 (UTC)
In-Reply-To: <bug-187231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=187231

--- Comment #2 from Patrick Schaaf <kernelorg@bof.de> ---
Thanks Don for the reaction!

Right now, on the box that had that panic and the worst resetting/reset issues
(see the other bug I linked), I'm back to 3.14.79, and want to stay there for
another 24 to 36 hours, to see that this issue was not present with that kernel
series.

What would your patch help with? Specifically the panic potential in case a
logical device reset is ongoing? Or should it affect / remedy the mysterious
(to me) "resetting logical" events in the first place?

I'm willing to test patches on that box starting Thursday, but I'd like to
understand a bit better what we are dealing with here.

-- 
You are receiving this mail because:
You are the assignee for the bug.
