From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 176951] boot fails unless acpi=off Acer Travelmate X-349
Date: Thu, 26 Jan 2017 08:07:57 +0000
Message-ID: <bug-176951-11613-2n6tkdxHfh@https.bugzilla.kernel.org/>
References: <bug-176951-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752829AbdAZIIB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 03:08:01 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id B2AD120481
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2017 08:07:58 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id BC5A02044B
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2017 08:07:57 +0000 (UTC)
In-Reply-To: <bug-176951-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=176951

Dmitry Sysoletin <dmitry.sysoletin@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dmitry.sysoletin@gmail.com

--- Comment #17 from Dmitry Sysoletin <dmitry.sysoletin@gmail.com> ---
Created attachment 253181
  --> https://bugzilla.kernel.org/attachment.cgi?id=253181&action=edit
Stacktrace screenshot 1

Screenshot of hung kernel 4.10.0-rc5

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
