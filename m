From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented and
 there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Fri, 22 Aug 2014 15:08:19 +0000
Message-ID: <bug-80711-11613-C1bs9py4Fm@https.bugzilla.kernel.org/>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58525 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756577AbaHVPIX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2014 11:08:23 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CF65720173
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2014 15:08:22 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E97C32018E
	for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2014 15:08:19 +0000 (UTC)
In-Reply-To: <bug-80711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80711

--- Comment #15 from Martin K. Petersen <martin.petersen@oracle.com> ---
>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:

Alan> Sending the initial INQUIRY command to LUNs larger than 0 involves
Alan> a chicken-and-egg problem -- we don't know whether to fill in the
Alan> LUN bits in the command until we know the SCSI level, and we don't
Alan> know the SCSI level until the INQUIRY response is received.  The
Alan> solution we have been using is to store the most recently
Alan> discovered level in the target structure, and use it as a default.
Alan> If probing starts with LUN 0, and if all the LUNs have similar
Alan> levels, this ought to work.

Looks good, Alan.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
You are receiving this mail because:
You are the assignee for the bug.
