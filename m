From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90291] New: Cannot access the FAT formatted sdcard of a Samsung
 cellphone model E2121L using linux
Date: Thu, 25 Dec 2014 03:57:12 +0000
Message-ID: <bug-90291-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54199 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbaLYD5Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Dec 2014 22:57:16 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id AB275201C7
	for <linux-scsi@vger.kernel.org>; Thu, 25 Dec 2014 03:57:15 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 5ACD7201E4
	for <linux-scsi@vger.kernel.org>; Thu, 25 Dec 2014 03:57:14 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90291

            Bug ID: 90291
           Summary: Cannot access the FAT formatted sdcard of a Samsung
                    cellphone model E2121L using linux
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.17.6-1-ARCH
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: freudian_order@yahoo.es
        Regression: No

Created attachment 161771
  --> https://bugzilla.kernel.org/attachment.cgi?id=161771&action=edit
lsusb, dmesg and journalctl output

Can't access the sdcard (the filesystem it uses is FAT) using linux. In the
settings of the cellphone I have set it to 'usb mass storage mode' and checking
lsusb I see it BUT I don't see it in the file manager and it has all empty
fields when checking lsblk (apart from name=sdb--sdb1). It works in windows so
the device does not seem to be flawed.

-- 
You are receiving this mail because:
You are the assignee for the bug.
