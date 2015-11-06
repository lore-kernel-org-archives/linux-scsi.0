From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 107371] I/O error when accessing disk in standby
Date: Fri, 06 Nov 2015 11:53:43 +0000
Message-ID: <bug-107371-11613-a8mL4tzrMW@https.bugzilla.kernel.org/>
References: <bug-107371-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56315 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161212AbbKFLxq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Nov 2015 06:53:46 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 038B820635
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2015 11:53:45 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 5F71320647
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2015 11:53:43 +0000 (UTC)
In-Reply-To: <bug-107371-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=107371

Mikael Grahn <nikmind@home.se> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
           Hardware|All                         |x86-64

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
