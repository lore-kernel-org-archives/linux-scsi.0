From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14831] mptsas - Use of ATA command pass-through results in
 unreliable operation - drive / controller resets
Date: Wed, 26 May 2010 08:08:09 GMT
Message-ID: <201005260808.o4Q889eO022622@demeter.kernel.org>
References: <bug-14831-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52244 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab0EZIIJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2010 04:08:09 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4Q889Ir022623
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 26 May 2010 08:08:09 GMT
In-Reply-To: <bug-14831-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=14831





--- Comment #26 from dujun@perabytes.com  2010-05-26 08:08:01 ---
It seems to us that the software raid growing has no problem at all with the
forced alignment patch.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
