From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Sun, 19 Jan 2014 12:14:11 +0000
Message-ID: <bug-60644-11613-saVPkVqL9g@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39436 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbaASMOO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jan 2014 07:14:14 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 33C1620148
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jan 2014 12:14:13 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4949F2013D
	for <linux-scsi@vger.kernel.org>; Sun, 19 Jan 2014 12:14:12 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

Konstantin <ktrackfd@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |ktrackfd@gmail.com

--- Comment #41 from Konstantin <ktrackfd@gmail.com> ---
Created attachment 122561
  --> https://bugzilla.kernel.org/attachment.cgi?id=122561&action=edit
dmesg showing mpt2sas errors with ibm m1015 in it mode (fw 19)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
