From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 59601] commit 97dec564fd4948e0e560869c80b76e166ca2a83e breaks
 communication with XYRATEX disk shelves
Date: Tue,  2 Jul 2013 22:13:29 +0000 (UTC)
Message-ID: <20130702221329.33FE911FA52@bugzilla.kernel.org>
References: <bug-59601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:47996 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab3GBWNc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jul 2013 18:13:32 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2202A20137
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2013 22:13:31 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 3D09020115
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2013 22:13:29 +0000 (UTC)
In-Reply-To: <bug-59601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=59601





--- Comment #7 from Jack Hill <jackhill@jackhill.us>  2013-07-02 22:13:28 ---
Created an attachment (id=106661)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=106661)
dmesg output with packet dumps

I have attached the dmesg output after applying the patch you provided.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
