From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented and
 there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Thu, 21 Aug 2014 21:43:50 +0000
Message-ID: <bug-80711-11613-Io4Rf6NXtX@https.bugzilla.kernel.org/>
References: <bug-80711-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58466 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbaHUVny (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2014 17:43:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 50B5E201D3
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2014 21:43:52 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D55EB201BB
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2014 21:43:50 +0000 (UTC)
In-Reply-To: <bug-80711-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80711

--- Comment #13 from Martin K. Petersen <martin.petersen@oracle.com> ---
>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:

Alan> Okay, here's a patch that implements the suggestion, except that I
Alan> put the flag in the Scsi_Host structure instead of the template.
Alan> This was to minimize the impact of the change.  Among the various
Alan> SCSI-over-USB transports, only the Bulk-Only transport gives the
Alan> LUN separately from the CDB.  I don't know if there are any
Alan> multi-LUN USB devices that don't use the Bulk-Only transport, but
Alan> if there are then they won't work if the LUN isn't stored in
Alan> CDB[1].

I'm in agreement with this approach.

-- 
You are receiving this mail because:
You are the assignee for the bug.
