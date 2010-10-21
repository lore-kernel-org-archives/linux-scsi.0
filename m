From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20112] dmesg spam: "scsi host5: __pm_runtime_resume() returns
 1" (DVD writer)
Date: Thu, 21 Oct 2010 18:31:25 GMT
Message-ID: <201010211831.o9LIVPW6012318@demeter2.kernel.org>
References: <bug-20112-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:59341 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab0JUSb0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Oct 2010 14:31:26 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9LIVPmw012319
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2010 18:31:25 GMT
In-Reply-To: <bug-20112-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=20112





--- Comment #1 from Daniel Hahler <linux-bugs@thequod.de>  2010-10-21 18:31:24 ---
This is related to CONFIG_PM_VERBOSE=y, unsetting it does not cause this
message spam.

Is this intentional?
Does it indicate some bug or broken hardware?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
