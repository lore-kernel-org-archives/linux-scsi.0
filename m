From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 77631] task scsi_eh_6:537 blocked for more than 120 seconds.
Date: Tue, 10 Jun 2014 21:50:50 +0000
Message-ID: <bug-77631-11613-IeCdnnQB9o@https.bugzilla.kernel.org/>
References: <bug-77631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47915 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbaFJVux (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2014 17:50:53 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D4084202EB
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 21:50:52 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 55A72202BE
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 21:50:51 +0000 (UTC)
In-Reply-To: <bug-77631-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=77631

--- Comment #4 from Mikhail <mikhail.v.gavrilov@gmail.com> ---
Created attachment 138991
  --> https://bugzilla.kernel.org/attachment.cgi?id=138991&action=edit
kernel log (second reboot) and plug/unplug USB3.0 hub

-- 
You are receiving this mail because:
You are the assignee for the bug.
