From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Tue, 27 Aug 2013 11:46:43 +0000
Message-ID: <bug-60644-11613-n2P4ZybwRC@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33715 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab3H0Lqs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 07:46:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CD1B820514
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2013 11:46:45 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id BAF982050F
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2013 11:46:44 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #21 from Hannes Reinecke <hare@suse.de> ---
Try with this patch. With a bit of luck it's just the firmware becoming
sluggish under high load, so disabling the watchdog will be circumvent this.
And any real error would still be handled by SCSI EH.

Keep fingers crossed.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
