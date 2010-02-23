From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15341] Load goes up very high when we traverse the large tree
Date: Tue, 23 Feb 2010 18:37:55 GMT
Message-ID: <201002231837.o1NIbtZe025238@demeter.kernel.org>
References: <bug-15341-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59710 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab0BWSh4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2010 13:37:56 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1NIbtQ3025240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2010 18:37:55 GMT
In-Reply-To: <bug-15341-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15341





--- Comment #10 from Frederic MASSOT <frederic@juliana-multimedia.com>  2010-02-23 18:37:47 ---
Hi,

With deadline IO scheduler, I was able to run "find" on a large tree and even
compile a kernel 2.6.32, the load has not exceeded 3.  :o)

Regards.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
