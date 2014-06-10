From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 77631] task scsi_eh_6:537 blocked for more than 120 seconds.
Date: Tue, 10 Jun 2014 21:44:36 +0000
Message-ID: <bug-77631-11613-TepdY4UlH2@https.bugzilla.kernel.org/>
References: <bug-77631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47748 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444AbaFJVoi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2014 17:44:38 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 024E820274
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 21:44:38 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8E76B202C8
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 21:44:36 +0000 (UTC)
In-Reply-To: <bug-77631-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=77631

--- Comment #2 from Mikhail <mikhail.v.gavrilov@gmail.com> ---
This occurred when I did first reboot after kernel update from 3.14.5 to
3.14.6.
After second reboot I have not seen this issue.
And I did not plug/unplug any USB devices when it occurred.

-- 
You are receiving this mail because:
You are the assignee for the bug.
