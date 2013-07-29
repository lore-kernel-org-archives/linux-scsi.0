From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] New: MPT2SAS drops all HDDs when under high I/O
Date: Mon, 29 Jul 2013 03:20:11 +0000
Message-ID: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58443 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab3G2DUO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Jul 2013 23:20:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5D24820122
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 03:20:13 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C55C52012F
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2013 03:20:11 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

            Bug ID: 60644
           Summary: MPT2SAS drops all HDDs when under high I/O
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.11
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: liveaxle@live.com
        Regression: No

I have this issue that refused to be solved no matter what I do . My ASRock
comes with onboard SAS controller (LSI 2308) , since I recieved it always does
this one thing : Drops all HDDs connected to it .

It happens only under heavy IO operations after a few minutes . I can recreate
it easily by running either dd , md5deep or even btrfs scrub .

Kernel locks , can't even shut it down from console and a quick ls
/dev/disk/by-id shows that all the HDDs connected to the SAS controller have
disappeared .

It happens with the stable kernel (3.9 and 3.10.3) and the mainline (3.11-rc2)
as of this day .

It's not a hardware issue , because I installed a Windows Server 2012 on the
same machine with a few HDDs I have laying around and beat the controller to
the ground and it never hanged . So I know it's a Linux-specific issue .

Dmesg logs before and after the issue are attached .

Thank you .

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
