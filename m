From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16447] BUG at drivers/scsi/scsi_lib.c:1113
Date: Fri, 23 Jul 2010 19:08:28 GMT
Message-ID: <201007231908.o6NJ8SBv016273@demeter.kernel.org>
References: <bug-16447-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59037 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab0GWTI3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jul 2010 15:08:29 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6NJ8SAk016274
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jul 2010 19:08:28 GMT
In-Reply-To: <bug-16447-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16447





--- Comment #1 from Jiri Slaby <jirislaby@gmail.com>  2010-07-23 19:08:25 ---
This is a dup of 16275.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
