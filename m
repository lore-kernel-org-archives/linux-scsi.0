From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 88591] SCSI_IOCTL_GET_IDLUN only returns 8 bits for the SCSI
 Target value
Date: Fri, 21 Nov 2014 08:39:41 +0000
Message-ID: <bug-88591-11613-0hQYVnqT8M@https.bugzilla.kernel.org/>
References: <bug-88591-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49898 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758003AbaKUIjn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 03:39:43 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D93E3201BB
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2014 08:39:42 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 75FE720176
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2014 08:39:41 +0000 (UTC)
In-Reply-To: <bug-88591-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=88591

Lei, Ni <zsurancher@163.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |zsurancher@163.com

--- Comment #2 from Lei, Ni <zsurancher@163.com> ---
(In reply to d gilbert from comment #1)
> As you may have noticed sysfs is a pretty bad mechanism
> for answering this type of question, compared to an ioctl.
> 
> Doug Gilbert

Since sysfs is not a good mechanism, why should this ioctl command be
deprecated ?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
