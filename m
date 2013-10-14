From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 62971] Kernel 3.11.1 and higher does not boot on VMware VM
Date: Mon, 14 Oct 2013 22:39:00 +0000
Message-ID: <bug-62971-11613-MaJkj9pjqg@https.bugzilla.kernel.org/>
References: <bug-62971-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40767 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757715Ab3JNWjD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Oct 2013 18:39:03 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5268520218
	for <linux-scsi@vger.kernel.org>; Mon, 14 Oct 2013 22:39:02 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 48C2420213
	for <linux-scsi@vger.kernel.org>; Mon, 14 Oct 2013 22:39:01 +0000 (UTC)
In-Reply-To: <bug-62971-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=62971

--- Comment #1 from Bojan Smojver <bojan@rexursive.com> ---
That patch fixes commit 839cb99e8f748391059d10388c8aea48a88c142c, which seem to
have introduced the problem.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
