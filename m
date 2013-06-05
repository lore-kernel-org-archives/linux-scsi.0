From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59301] New: mpt2sas0 fails after short time of work
Date: Wed,  5 Jun 2013 08:15:22 +0000 (UTC)
Message-ID: <bug-59301-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41500 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab3FEIPe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jun 2013 04:15:34 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D3F4D20609
	for <linux-scsi@vger.kernel.org>; Wed,  5 Jun 2013 08:15:29 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 09B6D205EB
	for <linux-scsi@vger.kernel.org>; Wed,  5 Jun 2013 08:15:24 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=59301

           Summary: mpt2sas0 fails after short time of work
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.5.0-32-generic ubuntu
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: pomozoff@gmail.com
        Regression: No


Created an attachment (id=103551)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=103551)
Full dmesg log

mpt2sas0 module v16.00.00.00 always fails after boot:

[ 1638.408402] mpt2sas0: SAS host is non-operational !!!!
[ 1638.409803] mpt2sas0: _base_fault_reset_work: Running mpt2sas_dead_ioc
thread success !!!!
[ 1638.412848] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[ 1638.412889] sd 1:0:0:0: [sdb]  
[ 1638.412893] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[ 1638.413845] mpt2sas0: removing handle(0x000a), sas_addr(0x4433221107000000)
[ 1638.414519] sd 1:0:1:0: [sdc] Synchronizing SCSI cache
[ 1638.414552] sd 1:0:1:0: [sdc]  
[ 1638.414555] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[ 1638.414708] mpt2sas0: removing handle(0x0009), sas_addr(0x4433221104000000)
[ 1638.415060] mpt2sas0: sending diag reset !!
[ 1638.572147] mpt2sas0: diag reset: FAILED

It fails on CentOS 6.4 and Ubuntu Server 12.04.2 LTS
Module v13 (it goes within latest linux distributives) fails same way.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
