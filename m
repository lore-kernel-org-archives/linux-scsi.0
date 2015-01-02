From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] New: panic on write to 3ware raid array
Date: Fri, 02 Jan 2015 14:31:33 +0000
Message-ID: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52865 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbbABObh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jan 2015 09:31:37 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4EB1E2025B
	for <linux-scsi@vger.kernel.org>; Fri,  2 Jan 2015 14:31:36 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8DC2720256
	for <linux-scsi@vger.kernel.org>; Fri,  2 Jan 2015 14:31:34 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

            Bug ID: 90601
           Summary: panic on write to 3ware raid array
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.16 and above
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: merlin@liao.homelinux.org
        Regression: No

Created attachment 162291
  --> https://bugzilla.kernel.org/attachment.cgi?id=162291&action=edit
panic log

Since kernel version 3.16 we are getting kernel panics and the panic message
*might* suggest that it's related to the raid controller we use.
I did try the kernel versions 3.17, 3.18 and also and it keeps crashing.
3.15.10 runs totally fine though.

I can reproduce the crash 100% with a simple DD command
dd if=/dev/zero of=test bs=1G count=10

I've attached the backtrace and tw_cli configruation options.
We have several cluster nodes so I can try patches or give additional
information when necessary.

-- 
You are receiving this mail because:
You are the assignee for the bug.
