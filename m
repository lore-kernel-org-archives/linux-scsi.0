From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101891] mvsas prep failed, NULL pointer dereference in
 mvs_slot_task_free+0x5/0x1f0 [mvsas]
Date: Fri, 05 Feb 2016 16:45:27 +0000
Message-ID: <bug-101891-11613-KNkpWA0Vyi@https.bugzilla.kernel.org/>
References: <bug-101891-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56661 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbcBEQp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2016 11:45:29 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DEBB220389
	for <linux-scsi@vger.kernel.org>; Fri,  5 Feb 2016 16:45:28 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9577D20397
	for <linux-scsi@vger.kernel.org>; Fri,  5 Feb 2016 16:45:27 +0000 (UTC)
In-Reply-To: <bug-101891-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D101891

D=C4=81vis <davispuh@gmail.com> changed:

           What    |Removed                     |Added
-----------------------------------------------------------------------=
-----
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
