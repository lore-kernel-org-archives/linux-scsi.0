From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111341] Firmware loader
Date: Mon, 08 Feb 2016 17:00:10 +0000
Message-ID: <bug-111341-11613-3BY5jBjqVW@https.bugzilla.kernel.org/>
References: <bug-111341-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45424 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754AbcBHRAO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Feb 2016 12:00:14 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8A3B2203B8
	for <linux-scsi@vger.kernel.org>; Mon,  8 Feb 2016 17:00:12 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id EA0DE2026D
	for <linux-scsi@vger.kernel.org>; Mon,  8 Feb 2016 17:00:10 +0000 (UTC)
In-Reply-To: <bug-111341-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111341

--- Comment #2 from walter59 <walter.moeller@moeller-it.net> ---
some new information :
driver used is not c600 intel
controller is intel c600 id 1d02 --- so it uses ahci driver.

The probleme is the changes in achi.c to mulipile irq for each drive .

this are the changes from 4.4 to 4.5  ---- init phase fails and kernel goes to
endless loop.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
