From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 96631] New: after Updating  kernel ,system failed to boot
Date: Tue, 14 Apr 2015 09:31:04 +0000
Message-ID: <bug-96631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37931 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbbDNJbH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Apr 2015 05:31:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AB38E2011E
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2015 09:31:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id F1ECB201EC
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2015 09:31:04 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=96631

            Bug ID: 96631
           Summary: after Updating  kernel ,system failed to boot
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: kernel-ml-3.19.2-1.el7.elrepo.x86_64
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: xiaozhe.ou@samsung.com
        Regression: No

Created attachment 174011
  --> https://bugzilla.kernel.org/attachment.cgi?id=174011&action=edit
failure info

We update the CentOS-7.0-1406-x86_64-DVD kernel to
kernel-ml-3.19.2-1.el7.elrepo.x86_64,then we reboot system and enter 3.19.2
kernel. The screen stop at boot message as attachment shows. But you can log in
use ssh, and "uname -a" show the system has been updated with new kernel.

Why the screen printing stopped and show failure boot with new kernel?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
