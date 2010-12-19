From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 25192] 3w-{9,x}xxx don't work on big-endian MIPS
Date: Sun, 19 Dec 2010 07:02:50 GMT
Message-ID: <201012190702.oBJ72oD5008732@demeter2.kernel.org>
References: <bug-25192-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:46038 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab0LSHCv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Dec 2010 02:02:51 -0500
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id oBJ72owf008733
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 19 Dec 2010 07:02:50 GMT
In-Reply-To: <bug-25192-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=25192





--- Comment #5 from Matt Turner <mattst88@gmail.com>  2010-12-19 07:02:43 ---
(In reply to comment #4)
> What slot do you have the card in, 32-bit or 64-bit?  Can you try the other
> size slot?  I.E. 32->64 or 64->32.

It's in a 64-bit slot, and the edge of the 32-bit slots is too thick for the
card to fit, so no-can-do.

> Are you local to Silicon Valley?

No. :(

I'll cover twa_probe() with printks and report back tomorrow.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
