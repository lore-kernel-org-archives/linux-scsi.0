From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 187231] kernel panic during hpsa MSI plus tg3 MSI
Date: Fri, 11 Nov 2016 09:54:23 +0000
Message-ID: <bug-187231-11613-yt2lu9cYjE@https.bugzilla.kernel.org/>
References: <bug-187231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932398AbcKKJy2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Nov 2016 04:54:28 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 82E522063E
        for <linux-scsi@vger.kernel.org>; Fri, 11 Nov 2016 09:54:26 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id 3D7F72063B
        for <linux-scsi@vger.kernel.org>; Fri, 11 Nov 2016 09:54:24 +0000 (UTC)
In-Reply-To: <bug-187231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=187231

--- Comment #5 from Patrick Schaaf <kernelorg@bof.de> ---
After almost 4 days my problematic box downgraded to 3.14.79, finally made some
noise, like this:

2016-11-11T03:31:10.608539+01:00 kvm3f kernel: [320020.727691] hpsa
0000:03:00.0: Abort request on C0:B0:T0:L0
2016-11-11T03:31:10.608555+01:00 kvm3f kernel: [320020.728175] hpsa
0000:03:00.0: cp ffff8868f2c17000 is reported invalid (probably means target
device no longer present)
2016-11-11T03:31:10.608557+01:00 kvm3f kernel: [320020.728796] hpsa
0000:03:00.0: cp ffff8868f2c17000 is reported invalid (probably means target
device no longer present)
2016-11-11T03:31:10.608558+01:00 kvm3f kernel: [320020.729389] hpsa
0000:03:00.0: FAILED abort on device C0:B0:T0:L0
2016-11-11T03:31:10.608560+01:00 kvm3f kernel: [320020.729708] hpsa
0000:03:00.0: resetting device 0:0:0:0
2016-11-11T03:31:26.968534+01:00 kvm3f kernel: [320037.081397] hpsa
0000:03:00.0: device is ready.

So, maybe there is a somewhat weirdly faulty drive in that array, which
otherwise does not show any (SMART / ILO logs) symptoms...

-- 
You are receiving this mail because:
You are the assignee for the bug.
