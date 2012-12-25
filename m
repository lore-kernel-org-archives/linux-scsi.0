From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51881] HighPoint RocketRAID 2720 fail to detect some SATA hdd
Date: Tue, 25 Dec 2012 12:50:54 +0000 (UTC)
Message-ID: <20121225125054.1782411FF01@bugzilla.kernel.org>
References: <bug-51881-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51657 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab2LYMu7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Dec 2012 07:50:59 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 323CC201A5
	for <linux-scsi@vger.kernel.org>; Tue, 25 Dec 2012 12:50:58 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 1DA472019D
	for <linux-scsi@vger.kernel.org>; Tue, 25 Dec 2012 12:50:56 +0000 (UTC)
In-Reply-To: <bug-51881-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=51881





--- Comment #6 from Kouichi ONO <kou1.ono@gmail.com>  2012-12-25 12:50:53 ---
3.7.1 with attached patch works fine, all hdds found.
Thanks!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
