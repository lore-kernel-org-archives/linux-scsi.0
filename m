From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85151] pm80xx + 7805H + HP SAS port expander =
 mpi_smp_completion 2604:smp IO status 0x2 and sas: expander ... discovery
 failed(0xffffffa6)
Date: Fri, 26 Sep 2014 10:16:17 +0000
Message-ID: <bug-85151-11613-yuZL4nDG1v@https.bugzilla.kernel.org/>
References: <bug-85151-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46289 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198AbaIZKQV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2014 06:16:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id ED126202F0
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2014 10:16:19 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 1EC132010E
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2014 10:16:18 +0000 (UTC)
In-Reply-To: <bug-85151-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85151

--- Comment #9 from linux-ide@crashplan.pro ---
Even with latest HP SAS expander firmware version 2.10 (CP022989, Sep 9th 2014,
PUF21000.bin e898facebe75c180c0a9e7d521d0285a), no drives attached, only the
7805H with one cable SFF-8643 to SFF-8088 (0.5 meter in length) to the external
(1C,PORT1C) of the expander, there are these failure messages:

[  117.805044] sas: DOING DISCOVERY on port 0, pid:134
[  117.807859] pm80xx mpi_smp_completion 2604:smp IO status 0x2
[  117.808354] sas: expander 5001438018c7ed26 discovery failed(0xffffffa6)
[  117.809010] sas: DONE DISCOVERY on port 0, pid:134, result:-90
[  117.809878] sas: DOING DISCOVERY on port 1, pid:134
[  117.810706] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  117.811277] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  117.811891] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  117.812443] sas: RG to ex 5001438018c7ed26 failed:0xffffffba
[  117.813380] sas: DONE DISCOVERY on port 1, pid:134, result:-70
[  117.814045] sas: DOING DISCOVERY on port 2, pid:134
[  117.814966] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  117.815649] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  117.816361] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  117.817032] sas: RG to ex 5001438018c7ed26 failed:0xffffffba
[  117.817804] sas: DONE DISCOVERY on port 2, pid:134, result:-70
[  117.818335] sas: DOING DISCOVERY on port 3, pid:134
[  117.819051] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  117.819646] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  117.820414] sas: smp_execute_task: task to dev 5001438018c7ed26 response:
0xffffffff status 0x8a
[  117.820964] sas: RG to ex 5001438018c7ed26 failed:0xffffffba
[  117.821709] sas: DONE DISCOVERY on port 3, pid:134, result:-70

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
