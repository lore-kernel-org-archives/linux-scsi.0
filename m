From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 153171] scsi host6: runtime PM trying to activate child device
 host6 but parent (2-2:1.0) is not active
Date: Fri, 19 Aug 2016 02:17:59 +0000
Message-ID: <bug-153171-11613-KSqW9Rozqx@https.bugzilla.kernel.org/>
References: <bug-153171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753571AbcHSCSD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Aug 2016 22:18:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id D5A412026F
        for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2016 02:18:01 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id A6ECA20270
        for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2016 02:17:59 +0000 (UTC)
In-Reply-To: <bug-153171-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=153171

--- Comment #2 from Martin K. Petersen <martin.petersen@oracle.com> ---
>>>>> "Heiner" == Heiner Kallweit <hkallweit1@gmail.com> writes:

Heiner> This issue is fixed by patch scsi: "core: configure runtime pm
Heiner> before calling device_add in scsi_add_host_with_dma" I sent on
Heiner> Aug 3rd.

Severely lacking in the reviews department, though :(

-- 
You are receiving this mail because:
You are the assignee for the bug.
