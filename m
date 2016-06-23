From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 120921] target: Unconfiguring ib_srpt triggers kernel crash
Date: Thu, 23 Jun 2016 12:01:01 +0000
Message-ID: <bug-120921-11613-bdufhfPtpn@https.bugzilla.kernel.org/>
References: <bug-120921-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41142 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbcFWMBF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2016 08:01:05 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9E5C8201CD
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2016 12:01:03 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id C3D18201BC
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2016 12:01:01 +0000 (UTC)
In-Reply-To: <bug-120921-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=120921

--- Comment #1 from Bart Van Assche <bvanassche@acm.org> ---
Note: applying the following patch series on top of v4.6.2 was sufficient to
make my test pass: "fix and simplify session shutdown"
(http://thread.gmane.org/gmane.linux.scsi.target.devel/12031).

-- 
You are receiving this mail because:
You are the assignee for the bug.
