From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 11646] QLA2xxx: Kernel deadlock on high load somewhere after
 2.6.20
Date: Tue, 31 Aug 2010 13:56:53 GMT
Message-ID: <201008311356.o7VDurCB006875@demeter1.kernel.org>
References: <bug-11646-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42641 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab0HaN5z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2010 09:57:55 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o7VDvh7H007022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 31 Aug 2010 13:57:43 GMT
In-Reply-To: <bug-11646-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=11646





--- Comment #36 from Bernd Zeimetz <bzed@debian.org>  2010-08-31 10:45:16 ---
On 08/31/2010 08:22 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
> Has there been a resolution yet on this issue?
> When you said "pci=nomsi seems to work" - has the problem got resolved for you
> using pci-nomsi?

pci=nomsi makes the machine work fine, indeed.
See Debian bug #572322 for details - the Debian Kernel ships a patch to allow
to
disable msi(-x) for the Qlogic cards now.

Cheers,

Bernd

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
