From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 156321] mpt3sas timeout with xen, works only with
 mpt3sas.msix_disable=1 (SAS3008 card)
Date: Thu, 08 Sep 2016 11:49:53 +0000
Message-ID: <bug-156321-11613-5y1nltoMnJ@https.bugzilla.kernel.org/>
References: <bug-156321-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753645AbcIHLt5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Sep 2016 07:49:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id D1AE820303
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2016 11:49:55 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id CD64A201C7
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2016 11:49:53 +0000 (UTC)
In-Reply-To: <bug-156321-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=156321

Sreekanth Reddy <sreekanth.reddy@broadcom.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |sreekanth.reddy@broadcom.co
                   |                            |m

--- Comment #1 from Sreekanth Reddy <sreekanth.reddy@broadcom.com> ---
Hi John,

Can you please try once with latest Phase13 SAS3008 HBA firmware.

Thanks,
Sreekanth

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
