From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16449] can't watch dvd using pata-ali or ata-generic
Date: Sat, 14 Aug 2010 22:44:42 GMT
Message-ID: <201008142244.o7EMigtM005574@demeter.kernel.org>
References: <bug-16449-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51323 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999Ab0HNWon (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Aug 2010 18:44:43 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o7EMigXY005575
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 14 Aug 2010 22:44:42 GMT
In-Reply-To: <bug-16449-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16449


Ben Kibbey <bjk@luxsci.net> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bjk@luxsci.net




--- Comment #2 from Ben Kibbey <bjk@luxsci.net>  2010-08-14 22:44:38 ---
I have this problem too. I was using the deprecated ATA modules without
problems. After switching to the pata-ali driver though the DVD consumes 100%
CPU. A normal IDE HDD with the pata-ali module seems to work fine.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
