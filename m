From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14563] SCSI tape driver: Spurious EIO and kernel OOPS
Date: Mon, 9 Nov 2009 08:31:34 GMT
Message-ID: <200911090831.nA98VY2M008091@demeter.kernel.org>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43862 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbZKIIb2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2009 03:31:28 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA98VYgI008092
	for <linux-scsi@vger.kernel.org>; Mon, 9 Nov 2009 08:31:34 GMT
In-Reply-To: <bug-14563-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14563





--- Comment #5 from Joachim Breuer <linux-kernel@jmbreuer.net>  2009-11-09 08:31:33 ---
Created an attachment (id=23707)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23707)
dmesg output from non-affected kernel 2.6.27.10 (after a successful
backup/test-restore run)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
