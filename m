From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 35682] killing requests for dead queue
Date: Tue, 19 Jul 2011 12:23:26 GMT
Message-ID: <201107191223.p6JCNQDk022608@demeter1.kernel.org>
References: <bug-35682-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:42373 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab1GSMX1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2011 08:23:27 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p6JCNQc6022609
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2011 12:23:26 GMT
In-Reply-To: <bug-35682-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=35682





--- Comment #4 from rpansky@gmail.com  2011-07-19 12:23:14 ---
I still cannot reproduce the panic with 2.6.39.3.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
