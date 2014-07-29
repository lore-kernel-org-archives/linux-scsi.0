From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented and
 there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Tue, 29 Jul 2014 15:57:32 +0000
Message-ID: <bug-80711-11613-Y5RedyvzAB@https.bugzilla.kernel.org/>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60715 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaG2P5j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2014 11:57:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3011F2011B
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2014 15:57:38 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 96E762014A
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2014 15:57:33 +0000 (UTC)
In-Reply-To: <bug-80711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80711

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk
            Summary|SG_FLAG_LUN_INHIBIT is no   |[PATCH]SG_FLAG_LUN_INHIBIT
                   |longer implemented and      |is no longer implemented
                   |there's not way to prevent  |and there's not way to
                   |the kernel from using the   |prevent the kernel from
                   |2nd cdb byte for the LUN    |using the 2nd cdb byte for
                   |                            |the LUN

--- Comment #3 from Alan <alan@lxorguk.ukuu.org.uk> ---
Patches need to go to the mailing list and/or maintainers. See
Documentation/SubmittingPatches. 

This is needed as we need a Signed-off-by: and valid email address.

-- 
You are receiving this mail because:
You are the assignee for the bug.
