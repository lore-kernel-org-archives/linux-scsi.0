From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 18862] [BUG]Kernel 2.6.36rc4 crash when rmmod pm8001
Date: Tue, 21 Sep 2010 18:58:19 GMT
Message-ID: <201009211858.o8LIwJpV022540@demeter2.kernel.org>
References: <bug-18862-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:39440 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0IUS6T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2010 14:58:19 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o8LIwJZd022541
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2010 18:58:19 GMT
In-Reply-To: <bug-18862-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=18862





--- Comment #1 from Rafael J. Wysocki <rjw@sisk.pl>  2010-09-21 18:58:17 ---
On Tuesday, September 21, 2010, Jack Wang wrote:
> Hi, Rafael and list
> 
> I recompile a clean 2.6.36rc4 kernel, and try to reproduce this BUG, but I
> cound not make this appear any more, sorry for that, maybe I hit the bug
> during I
> debug the libsas bug, sorry!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
