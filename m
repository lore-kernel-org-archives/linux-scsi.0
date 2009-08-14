From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13982] [libata] (?) causing Hardlock in 2.6.30.4 during
 simultaneous read & write
Date: Fri, 14 Aug 2009 08:30:36 GMT
Message-ID: <200908140830.n7E8Uaen008075@demeter.kernel.org>
References: <bug-13982-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40929 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbZHNIaf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2009 04:30:35 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7E8UaJD008076
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2009 08:30:36 GMT
In-Reply-To: <bug-13982-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13982





--- Comment #3 from Pavel Vilim <wylda@volny.cz>  2009-08-14 08:30:36 ---
Created an attachment (id=22716)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=22716)
First trace during 5days of testing/restarting...

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
