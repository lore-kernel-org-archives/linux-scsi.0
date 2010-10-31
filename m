From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 20112] dmesg spam: "scsi host5: __pm_runtime_resume() returns
 1" (DVD writer)
Date: Sun, 31 Oct 2010 20:48:57 GMT
Message-ID: <201010312048.o9VKmvu2026429@demeter2.kernel.org>
References: <bug-20112-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:50263 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab0JaUtA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Oct 2010 16:49:00 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9VKmwv1026430
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 31 Oct 2010 20:48:58 GMT
In-Reply-To: <bug-20112-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=20112


Nix <nix@esperi.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |nix@esperi.org.uk




--- Comment #2 from Nix <nix@esperi.org.uk>  2010-10-31 20:48:55 ---
I can confirm this logspam. In my case it relates to SCSI host 3, "CDDVDW
SH-S223F", a DVD writer. (The writer contains no media.)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
