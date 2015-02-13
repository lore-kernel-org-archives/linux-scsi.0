From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Fri, 13 Feb 2015 07:25:12 +0000
Message-ID: <bug-90601-11613-euG2vx3eYA@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34211 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbbBMHZQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2015 02:25:16 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E923C20266
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2015 07:25:13 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 784A620173
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2015 07:25:12 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

Alex Elsayed <eternaleye+kernelbugs@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |eternaleye+kernelbugs@gmail
                   |                            |.com

--- Comment #9 from Alex Elsayed <eternaleye+kernelbugs@gmail.com> ---
I've been bitten by this as well, on a 3ware 9750. It's currently preventing
from using recent kernels on the server in question - which is an issue,
because while 3.16.1 is rock-solid for scsi it has an intermittent wireless
oops, and 3.17.1 oopses out with this (same backtrace as the existing
attachment).

-- 
You are receiving this mail because:
You are the assignee for the bug.
