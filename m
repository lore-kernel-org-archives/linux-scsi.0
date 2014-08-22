From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 81861] Oops by mvsas v0.8.16: sas: ataX: end_device-Y:0:Z: dev
 error handler -> general protection fault, RIP: mvs_task_prep_ata+0x80/0x3a0
Date: Fri, 22 Aug 2014 14:05:25 +0000
Message-ID: <bug-81861-11613-cRj1GxfnJg@https.bugzilla.kernel.org/>
References: <bug-81861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55640 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120AbaHVOF2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2014 10:05:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 89231201BC
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2014 14:05:27 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 91A752018E
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2014 14:05:25 +0000 (UTC)
In-Reply-To: <bug-81861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=81861

--- Comment #10 from linux-ide@crashplan.pro ---
Another test round to see whether there is a difference in crash whether using
cold or warm boot:
5C + cold boot = mvs_task_prep+0x72e/0xd50 [mvsas]
5C + warm boot = mvs_task_prep+0x72e/0xd50 [mvsas]
6C + cold boot = mvs_task_prep+0x72e/0xd50 [mvsas]
6C + warm boot = mvs_task_prep+0x72e/0xd50 [mvsas]
7C + cold boot = mvs_task_prep+0x72e/0xd50 [mvsas]
7C + warm boot = mvs_task_prep+0x72e/0xd50 [mvsas]
8C + cold boot = mvs_task_prep+0x72e/0xd50 [mvsas]
8C + warm boot = mvs_task_prep+0x72e/0xd50 [mvsas]
9C + cold boot = mvs_task_prep+0x72e/0xd50 [mvsas]
9C + warm boot = mvs_task_prep+0x72e/0xd50 [mvsas]

In cases 6C, 7C and 9C the r8169 nic 
doesn't come up after the first automatic reboot after cold boot ("Waiting for
network configuration..." and "Waiting up to 60 more seconds for network
configuration...")
   does come up after the second automatic reboot after cold boot
[reproduceable=yes]

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
