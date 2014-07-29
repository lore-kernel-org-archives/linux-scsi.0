From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after
 2.6.20
Date: Tue, 29 Jul 2014 20:22:34 +0000
Message-ID: <bug-11646-11613-suAbSnNM9M@https.bugzilla.kernel.org/>
References: <bug-11646-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43435 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbaG2UWj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2014 16:22:39 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CD58820142
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2014 20:22:38 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B8398201BB
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2014 20:22:36 +0000 (UTC)
In-Reply-To: <bug-11646-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=11646

--- Comment #39 from Alan <alan@lxorguk.ukuu.org.uk> ---
Thanks

-- 
You are receiving this mail because:
You are the assignee for the bug.
