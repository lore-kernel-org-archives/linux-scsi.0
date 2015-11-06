From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107371] I/O error when accessing disk in standby
Date: Fri, 06 Nov 2015 13:15:23 +0000
Message-ID: <bug-107371-11613-RnztNWMumd@https.bugzilla.kernel.org/>
References: <bug-107371-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34266 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932883AbbKFNP3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Nov 2015 08:15:29 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C2C6D2063B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2015 13:15:28 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 96B072073B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2015 13:15:23 +0000 (UTC)
In-Reply-To: <bug-107371-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=107371

Mikael Grahn <nikmind@home.se> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|4.1.2                       |4.1.12

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
