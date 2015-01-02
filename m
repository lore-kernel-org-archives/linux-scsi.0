From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Fri, 02 Jan 2015 14:33:52 +0000
Message-ID: <bug-90601-11613-Y2qmwyhH1l@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52973 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbbABOdz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jan 2015 09:33:55 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8929F20259
	for <linux-scsi@vger.kernel.org>; Fri,  2 Jan 2015 14:33:54 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D36632024D
	for <linux-scsi@vger.kernel.org>; Fri,  2 Jan 2015 14:33:52 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

--- Comment #2 from merlin@liao.homelinux.org ---
I tried to mail "Adam Radford <linuxraid@lsi.com>" directly as stated in
drivers/scsi/3w-sas.c but the mail address doesn't exist anymore.

-- 
You are receiving this mail because:
You are the assignee for the bug.
