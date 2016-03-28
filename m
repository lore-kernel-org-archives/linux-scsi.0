From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 115351] redundant pointless messages
Date: Mon, 28 Mar 2016 01:38:06 +0000
Message-ID: <bug-115351-11613-H4gnLB0Td3@https.bugzilla.kernel.org/>
References: <bug-115351-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39849 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbcC1BiL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Mar 2016 21:38:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0B45920259
	for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2016 01:38:09 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 623932024C
	for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2016 01:38:07 +0000 (UTC)
In-Reply-To: <bug-115351-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=115351

--- Comment #3 from Jonathan <spamme@ecybernard.com> ---
 scsi 4:3:0:0: Wrong diagnostic page; asked for 7 got 0
I get bunches of these

-- 
You are receiving this mail because:
You are the assignee for the bug.
