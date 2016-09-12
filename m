From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 156321] mpt3sas timeout with xen, works only with
 mpt3sas.msix_disable=1 (SAS3008 card)
Date: Mon, 12 Sep 2016 07:59:55 +0000
Message-ID: <bug-156321-11613-0rFQO8dauM@https.bugzilla.kernel.org/>
References: <bug-156321-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756982AbcILIAB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Sep 2016 04:00:01 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id E88EB20373
        for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2016 07:59:59 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id 2BB4F2040F
        for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2016 07:59:56 +0000 (UTC)
In-Reply-To: <bug-156321-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=156321

--- Comment #3 from Sreekanth Reddy <sreekanth.reddy@broadcom.com> ---
Hi John,

Recently our FW team has fixed this type of issue in the Firmware. Maybe this
fix went in the Phase13 FW. So you may need to wait to some more time until
this Phase13 FW is available for outside.

Thanks,
Sreekanth

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
