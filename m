From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85101] hpsa + P410 does not show connected HP SAS port
 expanders
Date: Wed, 01 Oct 2014 21:59:30 +0000
Message-ID: <bug-85101-11613-Rl065woR66@https.bugzilla.kernel.org/>
References: <bug-85101-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:52773 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaJAV7d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2014 17:59:33 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D6D8F2026D
	for <linux-scsi@vger.kernel.org>; Wed,  1 Oct 2014 21:59:32 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0A1E82021A
	for <linux-scsi@vger.kernel.org>; Wed,  1 Oct 2014 21:59:31 +0000 (UTC)
In-Reply-To: <bug-85101-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85101

linux-ide@crashplan.pro changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|REOPENED                    |RESOLVED
         Resolution|---                         |DOCUMENTED

--- Comment #9 from linux-ide@crashplan.pro ---
This is expected behavior and not a bug because the HP P410 device is a SAS
RAID controller and not a serial attached scsi host bus adapter (SAS HBA).

A SAS RAID controller 
quote: "does not expose anything about the SAS fabric (expanders or physical
drives) to the OS"

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
