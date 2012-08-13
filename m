From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17822] drivers/scsi/ipr.c implicit declaration of function
 'writeq'
Date: Mon, 13 Aug 2012 16:25:56 +0000 (UTC)
Message-ID: <20120813162556.F046E11FC6C@bugzilla.kernel.org>
References: <bug-17822-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60059 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab2HMQ0A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2012 12:26:00 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DF1A1201BB
	for <linux-scsi@vger.kernel.org>; Mon, 13 Aug 2012 16:25:58 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id F150220204
	for <linux-scsi@vger.kernel.org>; Mon, 13 Aug 2012 16:25:56 +0000 (UTC)
In-Reply-To: <bug-17822-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=17822


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
                 CC|                            |alan@lxorguk.ukuu.org.uk
         Resolution|                            |CODE_FIX




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
