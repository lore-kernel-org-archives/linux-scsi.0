From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85101] hpsa + P410 does not show connected HP SAS port
 expanders
Date: Thu, 25 Sep 2014 14:05:59 +0000
Message-ID: <bug-85101-11613-ivDNotkyly@https.bugzilla.kernel.org/>
References: <bug-85101-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47467 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883AbaIYOGM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 10:06:12 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DB40D20295
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 14:06:02 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 3745320274
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 14:06:00 +0000 (UTC)
In-Reply-To: <bug-85101-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85101

linux-ide@crashplan.pro changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |REOPENED
         Resolution|UNREPRODUCIBLE              |---

--- Comment #5 from linux-ide@crashplan.pro ---
After replacing the faulty hardware, the HP P410 boots normally again.

However the P410+hpsa still does not detect either of the HP SAS expander
cards, neither does ./ccissflash detect any connected HP SAS expander.

LED status of the HP SAS expander card:
CR1 = solid green
CR2 = solid green
CR3 = solid green
CR4 = off
CR5 = off
CR6 = blinks green

Note: the Adaptec pm80xx module fails loading in sas expander discovery, I will
file a separate bug report for that.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
