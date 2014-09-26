From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85151] pm80xx + 7805H + HP SAS port expander =
 mpi_smp_completion 2604:smp IO status 0x2 and sas: expander ... discovery
 failed(0xffffffa6)
Date: Fri, 26 Sep 2014 08:34:00 +0000
Message-ID: <bug-85151-11613-6jbBUSPbEe@https.bugzilla.kernel.org/>
References: <bug-85151-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37103 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297AbaIZIeH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2014 04:34:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C5545202E6
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2014 08:34:01 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 63F72202F0
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2014 08:34:00 +0000 (UTC)
In-Reply-To: <bug-85151-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85151

--- Comment #7 from Jack Wang <xjtuwjp@gmail.com> ---
Cc pmchba maillist.

2014-09-25 18:20 GMT+02:00  <bugzilla-daemon@bugzilla.kernel.org>:
> https://bugzilla.kernel.org/show_bug.cgi?id=85151
>
> --- Comment #6 from Jack Wang <xjtuwjp@gmail.com> ---
> Ah, I forgot no bsg node if expander discover failed:(
> HBA SAS address is 0, does not matter.
>
> From my point, this bug clear SMP protocol related, you could report to PMC, I
> think they will offer help.
>
> --
> You are receiving this mail because:
> You are watching the assignee of the bug.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
