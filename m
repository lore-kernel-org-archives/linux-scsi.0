From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112241] New: Under heavy load FC TARGET going to Oops
Date: Wed, 10 Feb 2016 07:32:13 +0000
Message-ID: <bug-112241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58325 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbcBJHcU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2016 02:32:20 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 272C1202EB
	for <linux-scsi@vger.kernel.org>; Wed, 10 Feb 2016 07:32:16 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8EAD7202C8
	for <linux-scsi@vger.kernel.org>; Wed, 10 Feb 2016 07:32:14 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=112241

            Bug ID: 112241
           Summary: Under heavy load FC TARGET going to Oops
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 4.3.3
          Hardware: Intel
                OS: Linux
              Tree: Fedora
            Status: NEW
          Severity: high
          Priority: P1
         Component: QLOGIC QLA2XXX
          Assignee: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
          Reporter: anthony.bloodoff@gmail.com
        Regression: No

Created attachment 203261
  --> https://bugzilla.kernel.org/attachment.cgi?id=203261&action=edit
Kernel stacktrace

Storage on Linux Fedora with QLogic Corp. ISP2532-based 8Gb Fibre Channel to
PCI Express HBA exporting Adaptec RAID6 with bcache on Intel SSD to VMWARE 5
On heavy load (for example VM migrating from storage) system going to Oops.


Stacktrace attached

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
