From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85151] pm80xx + 7805H + HP SAS port expander =
 mpi_smp_completion 2604:smp IO status 0x2 and sas: expander ... discovery
 failed(0xffffffa6)
Date: Thu, 25 Sep 2014 15:53:58 +0000
Message-ID: <bug-85151-11613-nHJjtPl5iR@https.bugzilla.kernel.org/>
References: <bug-85151-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53708 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbaIYPyC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 11:54:02 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 74775202AE
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 15:54:01 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 203502020E
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 15:53:59 +0000 (UTC)
In-Reply-To: <bug-85151-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85151

--- Comment #4 from Jack Wang <xjtuwjp@gmail.com> ---
Could you check if the expander has new firmware?

you can also check smp support through smp_utils

http://sg.danny.cz/sg/smp_utils.html

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
