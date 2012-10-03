From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48241] New: oops when setting up LVM
Date: Wed,  3 Oct 2012 15:04:47 +0000 (UTC)
Message-ID: <bug-48241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43366 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab2JCPE6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2012 11:04:58 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 01DEF2008F
	for <linux-scsi@vger.kernel.org>; Wed,  3 Oct 2012 15:04:54 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 82C3520468
	for <linux-scsi@vger.kernel.org>; Wed,  3 Oct 2012 15:04:48 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=48241

           Summary: oops when setting up LVM
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.6.0-next-20121003
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: daniel.santos@pobox.com
        Regression: No


Created an attachment (id=81921)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=81921)
image of oops

see attached image

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
