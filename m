From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 17822] drivers/scsi/ipr.c implicit declaration of function
 'writeq'
Date: Sun, 5 Sep 2010 14:45:15 GMT
Message-ID: <201009051445.o85EjFGN012047@demeter1.kernel.org>
References: <bug-17822-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47570 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0IEOpQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2010 10:45:16 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o85EjFdJ012048
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sun, 5 Sep 2010 14:45:15 GMT
In-Reply-To: <bug-17822-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=17822





--- Comment #1 from Teej <xteejyx@googlemail.com>  2010-09-05 14:45:13 ---
Note: This is the 2.6.34-gentoo-r1 kernel for ppc

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
