From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Tue, 30 Jul 2013 10:03:46 +0000
Message-ID: <bug-60644-11613-SY3kBt9fQW@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39743 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164Ab3G3KDu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jul 2013 06:03:50 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0F1142043C
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2013 10:03:49 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9EC122045A
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jul 2013 10:03:46 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #11 from Sreekanth Reddy <sreekanth.reddy@lsi.com> ---
Hi,

Thanks for providing the logs.

>From the logs what I observed is that controller is going in to the non
operational state and so we are seeing the messages "mpt2sas0:
_base_fault_reset_work : SAS host is non-operational !!!!". 

So once the controller stays in this state then driver will remove this
controller's host entry from the scsi mid layer ( i.e. HBA's host is removed
from the /sys/class/scsi_host/hostX). And hence your are observing that all the
drivers attached to this controller are dropped.

But still I am not sure why controller enters in to the non-operational state. 
So,  I thought to reproduce this locally, So can you please help me in
reproducing this issue i.e. can you please tell me the steps and which utils
with cmds your are used to reproduce this issue.

Regards,
Sreekanth

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
