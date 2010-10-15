From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 18652] mptscsih: ioc0: attempting task abort when heavy disk
 operations on MPT SAS
Date: Fri, 15 Oct 2010 01:10:39 GMT
Message-ID: <201010150110.o9F1AdUJ010619@demeter2.kernel.org>
References: <bug-18652-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:42670 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab0JOBKk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Oct 2010 21:10:40 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o9F1Adht010621
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 15 Oct 2010 01:10:39 GMT
In-Reply-To: <bug-18652-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=18652





--- Comment #3 from pipa.tk <bigplum@gmail.com>  2010-10-15 01:10:37 ---

Yes, this patch not functioned completely. After I apply this patch with
2.6.18.8-xen and run for 2 days, IO still hang every 1~3 hours. It's more less
than before. The message shows: 

mptscsih: ioc0: attempting task abort! (sc=ffff88028efdcb40)
sd 4:0:6:0:
        command: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO Executed},
SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=ffff88028efdcb40)
mptscsih: ioc0: attempting task abort! (sc=ffff88028f12e080)
sd 4:0:6:0:
        command: Synchronize Cache(10): 35 00 00 00 00 00 00 00 00 00
mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO Executed},
SubCode(0x0000)
mptscsih: ioc0: task abort: SUCCESS (sc=ffff88028f12e080)

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
