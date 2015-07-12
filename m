From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101371] New: OOPS: unplugging western digital passport drive
Date: Sun, 12 Jul 2015 08:23:59 +0000
Message-ID: <bug-101371-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44710 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbbGLIYC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Jul 2015 04:24:02 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9923A20609
	for <linux-scsi@vger.kernel.org>; Sun, 12 Jul 2015 08:24:00 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id C1780205F1
	for <linux-scsi@vger.kernel.org>; Sun, 12 Jul 2015 08:23:59 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101371

            Bug ID: 101371
           Summary: OOPS: unplugging western digital passport drive
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.0.7
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: ilanco@gmail.com
        Regression: No

Created attachment 182471
  --> https://bugzilla.kernel.org/attachment.cgi?id=182471&action=edit
kernel log

Hi,

I can reproducibly crash my laptop by unplugging a western digital passport
drive.
The flow is as follow:

1. plugin in passport drive
2. wait until drivers are loaded
3. plug in or unplug power cable
4. unplug passport

This only happens after changing the power state of the laptop. So if I plug in
the passport drive while on BAT (or AC) and plug in out while on AC (or BAT)
the system crashes.

I think this is the same bug but for an older kernel version:
https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg37689.html

Kernel log is attached.

Friendly regards,

Ilan Cohen

-- 
You are receiving this mail because:
You are the assignee for the bug.
