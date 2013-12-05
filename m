From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Thu, 05 Dec 2013 18:00:05 +0000
Message-ID: <bug-60644-11613-lGUXmo2lcn@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:55467 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904Ab3LESAQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Dec 2013 13:00:16 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D39752053A
	for <linux-scsi@vger.kernel.org>; Thu,  5 Dec 2013 18:00:11 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 3C3312052F
	for <linux-scsi@vger.kernel.org>; Thu,  5 Dec 2013 18:00:07 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

Jeff Johnson <jeff.johnson@aeoncomputing.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jeff.johnson@aeoncomputing.
                   |                            |com

--- Comment #35 from Jeff Johnson <jeff.johnson@aeoncomputing.com> ---
Has anyone checked operating temp of the SAS chip on the HBAs?

Max operating temp is 55C. I'm seeing this issue on a box with three 9207-8i
running zfs and the operating climbs to 64-67C before a drop out occurs.

Temps can be checked with the lsiutil utility.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
