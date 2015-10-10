From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Sat, 10 Oct 2015 07:30:41 +0000
Message-ID: <bug-90601-11613-W2nO3Alosp@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:32980 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbbJJHap (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Oct 2015 03:30:45 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A011E20837
	for <linux-scsi@vger.kernel.org>; Sat, 10 Oct 2015 07:30:43 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 24973207FD
	for <linux-scsi@vger.kernel.org>; Sat, 10 Oct 2015 07:30:42 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #27 from Justin Keogh <kernel.org@v6y.net> ---
I am unable to reproduce this on any of the 4.x.y kernels.

-- 
You are receiving this mail because:
You are the assignee for the bug.
