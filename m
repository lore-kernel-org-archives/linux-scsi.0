From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 188061] On quad port QLE2564 can't add in target only 2 ports
Date: Mon, 21 Nov 2016 08:02:05 +0000
Message-ID: <bug-188061-11613-4Tzykt0EuX@https.bugzilla.kernel.org/>
References: <bug-188061-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751937AbcKUICK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 03:02:10 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id AEF7E20142
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2016 08:02:08 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id B9C3720155
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2016 08:02:05 +0000 (UTC)
In-Reply-To: <bug-188061-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188061

--- Comment #2 from Anthony <anthony.bloodoff@gmail.com> ---
targetcli-2.1.fb43-2.fc25.noarch
python3-rtslib-2.1.fb60-2.fc25.noarch

I found possible reason and ugly workaround:
in package RTSLib file utils.py change REGEXP to validate WWN

'naa': lambda wwn: re.match("naa\.[1235][0-9a-fA-F]{15}$", wwn),

but I can't understnad why my QLogic card uses strange port names:
0x15b0024ffaa536f and 0x315b0024ffaa536f
and why on quad ports card from port to port changes highest bit in portname

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
