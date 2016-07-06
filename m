From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121531] Adaptec 7805H SAS HBA (pm80xx): hangs when writing
 >80MB at once
Date: Wed, 06 Jul 2016 16:03:18 +0000
Message-ID: <bug-121531-11613-QE7E1NAfWg@https.bugzilla.kernel.org/>
References: <bug-121531-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48252 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753723AbcGFQDV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jul 2016 12:03:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 28C6E20154
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2016 16:03:20 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id AEF3B20148
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2016 16:03:18 +0000 (UTC)
In-Reply-To: <bug-121531-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=121531

--- Comment #10 from Martin von Wittich <martin.von.wittich@iserv.eu> ---
I forgot to mention: the issue is also reproducible on a Ubuntu 16.04 live
system with Linux 4.4, by running "dd if=/dev/zero of=/dev/sdX bs=1M
count=128".

-- 
You are receiving this mail because:
You are the assignee for the bug.
