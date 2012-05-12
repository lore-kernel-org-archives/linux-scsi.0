From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43234] New: kernel crashes whenever the thumbdrive or USB
 devices are remove
Date: Sat, 12 May 2012 06:07:38 +0000 (UTC)
Message-ID: <bug-43234-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:35996 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab2ELGHk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 May 2012 02:07:40 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BCC5320331
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2012 06:07:39 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id D1F9C20328
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2012 06:07:38 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=43234

           Summary: kernel crashes whenever the thumbdrive or USB devices
                    are remove
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.2.11 stable
          Platform: All
        OS/Version: Linux
              Tree: -mm
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: SCSI
        AssignedTo: linux-scsi@vger.kernel.org
        ReportedBy: htmldeveloper@gmail.com
        Regression: No


The laptop crashed whenever the USB devices are not gracefully unmounted:

http://www.flickr.com/photos/29072599@N08/7180142770/in/photostream

(or perhaps crashed due to some other unknown reasons).

Configuration:   3.2.11 kernel on Ubuntu 10.04 LTS 64-bit version.   LENOVO
V570 laptop (i4-2450M).

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
