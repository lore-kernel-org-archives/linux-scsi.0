From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 153171] New: scsi host6: runtime PM trying to activate child
 device host6 but parent (2-2:1.0) is not active
Date: Mon, 15 Aug 2016 19:55:39 +0000
Message-ID: <bug-153171-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42774 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbcHOTzn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2016 15:55:43 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 61ABF20389
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2016 19:55:41 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 16A4220383
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2016 19:55:40 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=153171

            Bug ID: 153171
           Summary: scsi host6: runtime PM trying to activate child device
                    host6 but parent (2-2:1.0) is not active
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.8.0-040800rc2-lowlatency
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: caravena@gmail.com
        Regression: No

Created attachment 228931
  --> https://bugzilla.kernel.org/attachment.cgi?id=228931&action=edit
dmesg_4.8.0-040800rc2-lowlatency

Mount USB Pendrive

dmesg:
[ 4630.693915] scsi host6: runtime PM trying to activate child device host6 but
parent (2-2:1.0) is not active

-- 
You are receiving this mail because:
You are the assignee for the bug.
