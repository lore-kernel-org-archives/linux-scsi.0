From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17822] drivers/scsi/ipr.c implicit declaration of function
 'writeq'
Date: Mon, 6 Sep 2010 11:56:20 GMT
Message-ID: <201009061156.o86BuKV1016716@demeter1.kernel.org>
References: <bug-17822-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35285 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0IFL4U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 07:56:20 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o86BuKhv016717
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 6 Sep 2010 11:56:20 GMT
In-Reply-To: <bug-17822-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=17822





--- Comment #2 from Rolf Eike Beer <eike-kernel@sf-tec.de>  2010-09-06 11:56:17 ---
This sounds very familar: https://bugzilla.kernel.org/show_bug.cgi?id=16971

Is this a regression from earlier releases?

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
