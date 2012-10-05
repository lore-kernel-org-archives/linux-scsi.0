From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48241] oops when setting up LVM
Date: Fri,  5 Oct 2012 18:38:09 +0000 (UTC)
Message-ID: <20121005183809.500FC11FC3E@bugzilla.kernel.org>
References: <bug-48241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:41213 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932699Ab2JESiL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Oct 2012 14:38:11 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E7F9020387
	for <linux-scsi@vger.kernel.org>; Fri,  5 Oct 2012 18:38:10 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 56D5B203C6
	for <linux-scsi@vger.kernel.org>; Fri,  5 Oct 2012 18:38:09 +0000 (UTC)
In-Reply-To: <bug-48241-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=48241





--- Comment #10 from Daniel Santos <daniel.santos@pobox.com>  2012-10-05 18:38:08 ---
Update: bug not present in Linus today (commit
ecefbd94b834fa32559d854646d777c56749ef1c)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
