From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 79901] [BISECTED]Extremely slow boot on Promise VTrak E610f due
 to sd_mod RSOC usage
Date: Tue, 29 Jul 2014 19:07:51 +0000
Message-ID: <bug-79901-11613-ViyKhyhm4Z@https.bugzilla.kernel.org/>
References: <bug-79901-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:40859 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbaG2THy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2014 15:07:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 8645B2018E
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2014 19:07:53 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A995D20158
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2014 19:07:52 +0000 (UTC)
In-Reply-To: <bug-79901-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=79901

--- Comment #3 from Janusz Dziemidowicz <rraptorr@nails.eu.org> ---
I've read that document before creating the patch. Now, I've read it again. I
must say I'm at a loss. In the patch attached to this bug entry I've already
included Signed-off-by line.
Can anyone point precisely what is wrong here?

-- 
You are receiving this mail because:
You are the assignee for the bug.
