From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 151631] "Synchronizing SCSI cache" fails during(and delays)
 reboot/shutdown
Date: Sun, 07 Aug 2016 15:06:42 +0000
Message-ID: <bug-151631-11613-PySX2z5zcx@https.bugzilla.kernel.org/>
References: <bug-151631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50694 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbcHGPGq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Aug 2016 11:06:46 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9CEFD2028D
	for <linux-scsi@vger.kernel.org>; Sun,  7 Aug 2016 15:06:44 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id CC03E2026F
	for <linux-scsi@vger.kernel.org>; Sun,  7 Aug 2016 15:06:42 +0000 (UTC)
In-Reply-To: <bug-151631-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=151631

icanrealizeum <icanrealizeum+bugzillakernelorg@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|<=4.7.0-g0cbbc42            |<=4.7.0-g0cbbc42
                   |                            |4.7.0-g52ddb7e

-- 
You are receiving this mail because:
You are the assignee for the bug.
