From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 26692] Fusion MPT SPI bringup takes 80 seconds when the kernel
 is quiet
Date: Wed, 15 Feb 2012 21:08:09 GMT
Message-ID: <201202152108.q1FL893G011597@bugzilla.kernel.org>
References: <bug-26692-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:58991 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab2BOVIJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2012 16:08:09 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1FL892F011598
	for <linux-scsi@vger.kernel.org>; Wed, 15 Feb 2012 21:08:09 GMT
In-Reply-To: <bug-26692-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=26692





--- Comment #7 from Jonathan Nieder <jrnieder@gmail.com>  2012-02-15 21:08:07 ---
(In reply to comment #5)
> scsi0 : ioc0: LSI53C1030 B2, FwRev=01000e00h, Ports=1, MaxQ=222, IRQ=27

Is there a firmware update available?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
