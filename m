From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Fri, 13 Feb 2015 08:28:49 +0000
Message-ID: <bug-90601-11613-e4iWFCvUk9@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36288 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbbBMI2y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2015 03:28:54 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id EDC28200F0
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2015 08:28:52 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id BBB3020265
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2015 08:28:50 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #11 from merlin@liao.homelinux.org ---
I can confirm it's still happening with 3.19 here.

@Alex: What server hardware are you using? We are using Supermicro boards and
Intel CPUs.

-- 
You are receiving this mail because:
You are the assignee for the bug.
