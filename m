From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85151] pm80xx + 7805H + HP SAS port expander =
 mpi_smp_completion 2604:smp IO status 0x2 and sas: expander ... discovery
 failed(0xffffffa6)
Date: Thu, 25 Sep 2014 16:06:52 +0000
Message-ID: <bug-85151-11613-UxeI9zYBmu@https.bugzilla.kernel.org/>
References: <bug-85151-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54433 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbaIYQHD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 12:07:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E369A2020E
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 16:06:58 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 24BA92027D
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 16:06:53 +0000 (UTC)
In-Reply-To: <bug-85151-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85151

--- Comment #5 from linux-ide@crashplan.pro ---
Yes, the expander has new firmware (v. 2.10 available since early September).

Although my guess is that a firmware upgrade will not be possible as long as
the SAS HBA has an address (a.k.a. initiator port identifier) of 0:

# lsscsi -Ht | grep pm80xx
[4]    pm80xx        sas:0x0000000000000000

# ls /dev/bsg/ex*
ls: cannot access /dev/bsg/ex*: No such file or directory

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
