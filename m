From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15950] Hang in dc395x driver
Date: Sun, 16 May 2010 03:49:19 GMT
Message-ID: <201005160349.o4G3nJ4u010196@demeter.kernel.org>
References: <bug-15950-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:38744 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab0EPDtU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 May 2010 23:49:20 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4G3nJkL010225
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 16 May 2010 03:49:19 GMT
In-Reply-To: <bug-15950-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15950


ltskinol@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Regression|Yes                         |No




--- Comment #5 from ltskinol@gmail.com  2010-05-16 03:49:14 ---
Guennadi - good call.

I was able to go back to kernel 2.6.22.1 (through 2.6.25/24/23) and all
versions exhibit the same behavior.  With the command-line scanimage software,
I eventually see an error returned and the driver resets after a two minute
delay.

I've removed the regression flag from this bug, but still think there's a
problem.

Tom

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
