From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Wed, 28 Aug 2013 08:32:48 +0000
Message-ID: <bug-60644-11613-rH1CocX9qV@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41661 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab3H1Icx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Aug 2013 04:32:53 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 6B79220326
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2013 08:32:52 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C96C120364
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2013 08:32:49 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

--- Comment #24 from liveaxle@live.com ---
Hello .

I used to have the same issues with MD . yes .

I'm using BTRFS , I don't know if BTRFS RAID code was ported from MD , but the
issue is the same .

I didn't try anything other than BTRFS and MD . Maybe I should give ZFS a try ,
although it is still slower on linux .

I'll report back as soon as possible .

Thank you .

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
