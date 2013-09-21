From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 61771] Support for LSI Logic / Symbios Logic M1064E MegaRAID
 SAS
Date: Sat, 21 Sep 2013 00:41:57 +0000
Message-ID: <bug-61771-11613-zRQGcBWF6i@https.bugzilla.kernel.org/>
References: <bug-61771-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43861 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab3IUAmF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Sep 2013 20:42:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 47DBC204CB
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2013 00:42:03 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id CCD4D204AF
	for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2013 00:42:01 +0000 (UTC)
In-Reply-To: <bug-61771-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=61771

Adam Radford <aradford@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |aradford@gmail.com

--- Comment #1 from Adam Radford <aradford@gmail.com> ---
04:00.0 SCSI storage controller: LSI Logic / Symbios Logic M1064E MegaRAID SAS
(rev 04)
04:00.0 0100: 1000:0057 (rev 04)

LSI MegaRAID device id 0x57 is really an old "software raid" embedded solution.

Support for this device existed in a closed source driver called "megasr", and
will not be added to the open source megaraid_sas drivers.

-Adam Radford @ LSI

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
