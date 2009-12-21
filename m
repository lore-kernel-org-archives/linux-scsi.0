From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Mon, 21 Dec 2009 12:11:32 GMT
Message-ID: <200912211211.nBLCBWdL021458@demeter.kernel.org>
References: <bug-14831-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46031 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZLUMLc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2009 07:11:32 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBLCBWxp021459
	for <linux-scsi@vger.kernel.org>; Mon, 21 Dec 2009 12:11:32 GMT
In-Reply-To: <bug-14831-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #7 from Tim Small <tim@seoss.co.uk>  2009-12-21 12:11:31 ---
Created an attachment (id=24243)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=24243)
Script to stress-test ATA command passthrough whilst write-loading a SATA
device.

This script uses dd to repeatedly write and remove a 1G zero-filled file
to/from a file-system whilst executing smartctl against the associated device
file.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
