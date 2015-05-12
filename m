From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16058] [BUG] Cannot boot any kernel from 2.6.27 on if a 256
 byte sector SCSI disk is attached
Date: Tue, 12 May 2015 13:24:40 +0000
Message-ID: <bug-16058-11613-gVrWQSTRXQ@https.bugzilla.kernel.org/>
References: <bug-16058-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33820 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757AbbELNYn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2015 09:24:43 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 66ABF20426
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 13:24:42 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 742DE2041D
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 13:24:41 +0000 (UTC)
In-Reply-To: <bug-16058-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16058

Mark Hounschell <dmarkh@cfl.rr.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dmarkh@cfl.rr.com

--- Comment #16 from Mark Hounschell <dmarkh@cfl.rr.com> ---
This bug is still valid. A 256 byte sector disk will cause kernel-4.0.2 to
hang.
Every since this bug was reported I have rolled my own patch that causes 256
byte sector disk to be unsupported for a linux fs. I use these disks in raw
mode using sg3 API only. No one would ever use these disks for a linux fs. I
would be happy to submit this patch. 

Mark

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
