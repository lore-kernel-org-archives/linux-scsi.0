From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 84091] Unloading qla2xxx kernel module triggers segmentation
 fault
Date: Mon, 08 Sep 2014 15:08:14 +0000
Message-ID: <bug-84091-11613-9XhHORpYyV@https.bugzilla.kernel.org/>
References: <bug-84091-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:50097 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbaIHPIV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Sep 2014 11:08:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E22EA20138
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2014 15:08:19 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DD3ED2015A
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2014 15:08:14 +0000 (UTC)
In-Reply-To: <bug-84091-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=84091

Joe Lawrence <joe.lawrence@stratus.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |joe.lawrence@stratus.com

--- Comment #1 from Joe Lawrence <joe.lawrence@stratus.com> ---
Hi Bart,

Does the following patch queued up in Christoph's tree fix the use-after-free?

cf6dc619eb7c qla2xxx: Fix shost use-after-free on device removal

http://git.infradead.org/users/hch/scsi-queue.git/commit/cf6dc619eb7cfadd9e44d384fb06672a157024ab

Regards,

-- Joe

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
