From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14159] AIC79xx is not working properly with an attached scsi
 tape since 2.6.29
Date: Tue, 15 Sep 2009 07:05:48 GMT
Message-ID: <200909150705.n8F75mDf004633@demeter.kernel.org>
References: <bug-14159-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:36075 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898AbZIOHFo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2009 03:05:44 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8F75mOx004634
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2009 07:05:48 GMT
In-Reply-To: <bug-14159-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14159





--- Comment #7 from g.giorgetti@teamsystem.com  2009-09-15 07:05:46 ---
Hi Bjorn and James,

pci=noacpi is not working, so even before reading Bjorn's reply, we tried
"noapic" and the suddenly the tape device was working again. No more timeouts
on initialization and so on.

I haven't tried pci=noioapicquirk yet, since the server is up for production
and other people is working. 
So I'm gonna do that later in the day.

Thank you very much for now.

Regards,
 Gabriele

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
