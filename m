From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 18652] mptscsih: ioc0: attempting task abort when heavy disk
 operations on MPT SAS
Date: Tue, 30 Nov 2010 09:55:24 GMT
Message-ID: <201011300955.oAU9tOjX026524@demeter1.kernel.org>
References: <bug-18652-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:42671 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab0K3JzZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2010 04:55:25 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id oAU9tO6G026525
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2010 09:55:24 GMT
In-Reply-To: <bug-18652-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=18652


ksb@inbox.lv changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|2.6.35.4 - 2.6.36           |2.6.35.4 - 2.6.36.1




-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
