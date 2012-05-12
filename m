From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 9215] When trying to get the drive status via ioctl
 CDROM_DRIVE_STATUS, with no disk  it gives CDS_TRAY_OPEN even if the tray is
 closed on SATA/SCSI devices
Date: Sat, 12 May 2012 16:21:33 +0000 (UTC)
Message-ID: <20120512162133.8978611FCE2@bugzilla.kernel.org>
References: <bug-9215-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:59852 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106Ab2ELQVf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 May 2012 12:21:35 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E4B2B203C2
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2012 16:21:34 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 8C03C203B8
	for <linux-scsi@vger.kernel.org>; Sat, 12 May 2012 16:21:33 +0000 (UTC)
In-Reply-To: <bug-9215-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=9215


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|RESOLVED                    |CLOSED




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
