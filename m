From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 18652] mptscsih: ioc0: attempting task abort when heavy disk
 operations on MPT SAS
Date: Thu, 4 Nov 2010 09:59:48 GMT
Message-ID: <201011040959.oA49xm6t017320@demeter1.kernel.org>
References: <bug-18652-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49017 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab0KDJ7s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2010 05:59:48 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oA49xmsu017321
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 4 Nov 2010 09:59:48 GMT
In-Reply-To: <bug-18652-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=18652





--- Comment #5 from ksb@inbox.lv  2010-11-04 09:59:46 ---
As I said before - happens only on WD'c, exactly WD2500AAKS. It don't happen on
other older hdd's, i.e. WDC WD2500KS.
HDD's are connected to 6-Drive Hot-Swap Expander Board AXX6DRV3GEXP, but when I
attach SATA hdd's directly to mainboard - everything works ok, without any
errors.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
