From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 116771] NULL pointer dereference when 'cat
 /sys/class/fc_host/host1/fabric_name'
Date: Sun, 03 Jul 2016 02:45:24 +0000
Message-ID: <bug-116771-11613-qkjn4rm5PF@https.bugzilla.kernel.org/>
References: <bug-116771-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40392 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbcGCCp2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Jul 2016 22:45:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DAB3920259
	for <linux-scsi@vger.kernel.org>; Sun,  3 Jul 2016 02:45:26 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D88052034C
	for <linux-scsi@vger.kernel.org>; Sun,  3 Jul 2016 02:45:24 +0000 (UTC)
In-Reply-To: <bug-116771-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=116771

bastienphilbert@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bastienphilbert@gmail.com

--- Comment #2 from bastienphilbert@gmail.com ---
See if the below patch triggers anything new for you.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
