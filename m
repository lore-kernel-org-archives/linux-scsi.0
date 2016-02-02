From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111731] New: mpt2sas doesn't get built
Date: Tue, 02 Feb 2016 09:55:55 +0000
Message-ID: <bug-111731-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:35978 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216AbcBBJz6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Feb 2016 04:55:58 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4E1BF202EB
	for <linux-scsi@vger.kernel.org>; Tue,  2 Feb 2016 09:55:57 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id ABBE8202C8
	for <linux-scsi@vger.kernel.org>; Tue,  2 Feb 2016 09:55:55 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111731

            Bug ID: 111731
           Summary: mpt2sas doesn't get built
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.4.0
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: nux@li.nux.ro
        Regression: No

Hello,

It looks like 4.4.0 is not building mpt2sas modules any more.
We got bit by this while testing it (via ElRepo) on EL7.

Even though specified in the config, only mpt3sas is built.

While mpt3sas can indeed support the hardware in question (DELL/LSI H200 in my
case), dracut/mkinitrd fails to include it in the initrd, because it's looking
for mpt2sas which is missing from /lib/modules altogether.

`dracut --add-drivers` solves the problem, but this is not a graceful kernel
upgrade and ends up with unbootable OS.

More information about this issue here http://elrepo.org/bugs/view.php?id=628

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
