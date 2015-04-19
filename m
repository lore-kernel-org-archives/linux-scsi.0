From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Sun, 19 Apr 2015 04:21:05 +0000
Message-ID: <bug-90601-11613-2WsYF1tgeb@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57091 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbbDSEVJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Apr 2015 00:21:09 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B93DC20457
	for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2015 04:21:08 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 43BCC20454
	for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2015 04:21:06 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #25 from Justin Keogh <kernel.org@v6y.net> ---
Just to clarify, I couldn't trigger this by writing to the array from /dev/zero
at all (maybe because ZFS), all panics were triggered by writing real data from
another array on the same controller.

-- 
You are receiving this mail because:
You are the assignee for the bug.
