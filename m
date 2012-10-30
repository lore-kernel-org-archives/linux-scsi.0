From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after
 2.6.20
Date: Tue, 30 Oct 2012 15:12:25 +0000 (UTC)
Message-ID: <20121030151225.93A0111FB29@bugzilla.kernel.org>
References: <bug-11646-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:51042 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab2J3PM3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Oct 2012 11:12:29 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 05C372032E
	for <linux-scsi@vger.kernel.org>; Tue, 30 Oct 2012 15:12:28 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id C996A20352
	for <linux-scsi@vger.kernel.org>; Tue, 30 Oct 2012 15:12:26 +0000 (UTC)
In-Reply-To: <bug-11646-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=11646


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|                            |OBSOLETE




--- Comment #37 from Alan <alan@lxorguk.ukuu.org.uk>  2012-10-30 15:12:24 ---
If this is still seen on modern kernels then please re-open/update

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
