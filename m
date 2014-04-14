From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 74011] New: strange observation, the queue depth is (64)
 meanwhile fw queue depth (65)
Date: Mon, 14 Apr 2014 08:48:51 +0000
Message-ID: <bug-74011-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37177 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbaDNIsy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2014 04:48:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D74C6201FA
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2014 08:48:52 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8C660201ED
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2014 08:48:51 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=74011

            Bug ID: 74011
           Summary: strange observation, the queue depth is (64) meanwhile
                    fw queue depth (65)
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.2 to 3.14.0
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: rblists@gmail.com
        Regression: No

Created attachment 132121
  --> https://bugzilla.kernel.org/attachment.cgi?id=132121&action=edit
System information

I get this error on the disk containing the root partition
This happens on recent kernels, but not on the 2.6.32.61 kernel.
The code generating these messages is however identical in 2.6.32.61 and newer
kernels.
This doesn't especially happen when the system is under high load.

This happens on both our production and stand-by server. Production server was
switched back to 2.6.32.61.

Attached file contains system information of the stand-by server running kernel
3.14.0 (cpuinfo.txt  lspci.txt  meminfo.txt  proc_scsi_scsi.txt 
ver_linux.txt).

I can provide more info and perform tests if needed.

-- 
You are receiving this mail because:
You are the assignee for the bug.
