From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151661] Adaptec 3805 prints "AAC: Host adapter dead -1" every
 10 seconds but works fine anyway
Date: Thu, 11 Aug 2016 15:55:14 +0000
Message-ID: <bug-151661-11613-r78XBTzwbF@https.bugzilla.kernel.org/>
References: <bug-151661-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59896 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932658AbcHKPzS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2016 11:55:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D2A622024D
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 15:55:16 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 0401D202EC
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 15:55:15 +0000 (UTC)
In-Reply-To: <bug-151661-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151661

--- Comment #3 from Piotr Szymaniak <bugzie@grubelek.pl> ---
Created attachment 228391
  --> https://bugzilla.kernel.org/attachment.cgi?id=228391&action=edit
dmesg with mentioned Alex patch

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
