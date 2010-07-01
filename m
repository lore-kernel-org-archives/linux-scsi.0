From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15688] mptsas & poor performance
Date: Thu, 1 Jul 2010 09:25:20 GMT
Message-ID: <201007010925.o619PKfl010258@demeter.kernel.org>
References: <bug-15688-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37738 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0GAJZW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2010 05:25:22 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o619PLH8010264
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 1 Jul 2010 09:25:21 GMT
In-Reply-To: <bug-15688-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15688





--- Comment #9 from Albert Strasheim <fullung@gmail.com>  2010-07-01 09:25:06 ---
I found 4.22.00.00 to be a bit slower than the driver that comes with RHEL 6's
2.6.32.

I would really like to understand what is causing the throughput per disk to
drop when one starts writing to more than 7 disks at the same time over one
PHY.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
