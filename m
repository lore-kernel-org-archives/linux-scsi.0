Return-Path: <SRS0=h99Q=3K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7982C33CAA
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 05:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E47324125
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 05:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgAUFdq convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jan 2020 00:33:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:50736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgAUFdq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Jan 2020 00:33:46 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 206261] New: LEDs are off for AHCI connected drives on Cisco
 C125 server
Date:   Tue, 21 Jan 2020 05:33:44 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: bvardham@cisco.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-206261-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=206261

            Bug ID: 206261
           Summary: LEDs are off for AHCI connected drives on Cisco C125
                    server
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: kernel-debug-5.4.11-1.1.g2d02eb4.x86_64.rpm
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: bvardham@cisco.com
        Regression: No

Created attachment 286915
  --> https://bugzilla.kernel.org/attachment.cgi?id=286915&action=edit
Attaching the support config logs.

Observed that on linux OS the LED of the drives are completely off (both
Presence and Locate LED) for the AHCI connected drives on the Cisco UCS C125
server.

Note : - Tried on Rhel7.7 OS and Sles 12 SP4 OS, on both LEDs were off, but on
Rhel7.7 OS provided  "libahci.ahci_em_messages=0" in the grub after with which
LED worked on the Rhel7.7, but on SLes 12SP4 and other linux distributions not
able to pass the "libahci.ahci_em_messages=0" ,and LED of the drives are not
blowing.


Tested with latest upstream kernel of version
"kernel-debug-5.4.11-1.1.g2d02eb4.x86_64.rpm" then also issue is persisting.

Expected Behavior: 
The LED of the drives should work even on Linux OSes.

Attached the support config logs with this bug.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
