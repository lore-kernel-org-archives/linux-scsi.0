From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 70751] mpt2sas: system disks dropped when execute SMART tests
Date: Fri, 21 Mar 2014 13:44:43 +0000
Message-ID: <bug-70751-11613-5ti7QGEuuX@https.bugzilla.kernel.org/>
References: <bug-70751-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33721 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbaCUNor (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2014 09:44:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 542F7202A1
	for <linux-scsi@vger.kernel.org>; Fri, 21 Mar 2014 13:44:46 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A04102028D
	for <linux-scsi@vger.kernel.org>; Fri, 21 Mar 2014 13:44:43 +0000 (UTC)
In-Reply-To: <bug-70751-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=70751

--- Comment #2 from Mihaly, A. Toth <mihaly.arva-toth+kernelorg@virtual-call-center.eu> ---
I tried with a newer kernel (3.13.6) and the problem still exists.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
