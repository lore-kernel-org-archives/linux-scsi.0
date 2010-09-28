From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Tue, 28 Sep 2010 19:07:15 GMT
Message-ID: <201009281907.o8SJ7F1g001513@demeter1.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47192 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab0I1THQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2010 15:07:16 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o8SJ7Fnc001514
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2010 19:07:15 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831


Benjamin ESTRABAUD <be@mpstor.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |be@mpstor.com




--- Comment #43 from starlight@binnacle.cx  2010-08-31 08:17:07 ---
Above recent activity reported by me assigned as new bug 17551 as it's
apparently not related to the 'smartd' failure.

--- Comment #44 from Benjamin ESTRABAUD <be@mpstor.com>  2010-09-28 19:07:00 ---
Is the fix suggested in previous comment #15
(http://lkml.org/lkml/2010/4/26/335) not the same as a proposed commit from
Yuri Tikonov in september 09?

reference: (https://kerneltrap.org/mailarchive/linux-scsi/2009/9/1/6371653)

Is the one suggested in mptscsih.c more 'global' than the one suggested in
mptsas.c by Yuri? Or are they complementary/redundant/different?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
