From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 106871] New: Lower log level for "No Caching mode page found"
 and "Assuming drive cache: write through"
Date: Thu, 29 Oct 2015 08:29:00 +0000
Message-ID: <bug-106871-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43527 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbbJ2I3C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2015 04:29:02 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A6AFD209E1
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 08:29:01 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id E2753209AC
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 08:29:00 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=106871

            Bug ID: 106871
           Summary: Lower log level for "No Caching mode page found" and
                    "Assuming drive cache: write through"
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.2.4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: tom.ty89@gmail.com
        Regression: No

Is there any particular reason that these two should be of error level? I don't
see why we should pay that much of attention to them since it's just how
vendors implemented the drive. Neither can the users or should they do anything
to fix it. IMHO they should be of notice level or at most warning.

-- 
You are receiving this mail because:
You are the assignee for the bug.
