From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 71231] System unresponsable after a lot of LUNs have been added
 to the system
Date: Fri, 28 Feb 2014 16:40:34 +0000
Message-ID: <bug-71231-11613-YQgWOGDfE1@https.bugzilla.kernel.org/>
References: <bug-71231-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54976 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbaB1Qkg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Feb 2014 11:40:36 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EA69D202A1
	for <linux-scsi@vger.kernel.org>; Fri, 28 Feb 2014 16:40:35 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 661D22026F
	for <linux-scsi@vger.kernel.org>; Fri, 28 Feb 2014 16:40:34 +0000 (UTC)
In-Reply-To: <bug-71231-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=71231

--- Comment #5 from Alex <alexandernaumann@gmx.de> ---
This bug can be "easily" reproduced by havin two machines with one fibre
channel card each.
Install scst on one machine (as target) and conenct the other one to this one
(via two cables).
Than add 20 LUNs and open them to teh other device via both ports (so the
crashing device should get 40 new LUNs) and rescan the SCSI bus.
(
echo 1 > /sys/class/fc_host/host<NR>/issue_lip
echo "- - -" > /sys/class/scsi_host/host<NR>/scan
)

BTW: I have multipath-tools installed also.

-- 
You are receiving this mail because:
You are the assignee for the bug.
