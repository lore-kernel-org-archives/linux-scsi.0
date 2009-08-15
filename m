From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13982] [libata] (?) causing Hardlock in 2.6.30.4 during
 simultaneous read & write
Date: Sat, 15 Aug 2009 18:01:09 GMT
Message-ID: <200908151801.n7FI19PV009552@demeter.kernel.org>
References: <bug-13982-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:47682 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZHOSBH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Aug 2009 14:01:07 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n7FI19AD009553
	for <linux-scsi@vger.kernel.org>; Sat, 15 Aug 2009 18:01:09 GMT
In-Reply-To: <bug-13982-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13982





--- Comment #6 from Roland Kletzing <devzero@web.de>  2009-08-15 18:01:07 ---
is it possible to temporarly disable/remove the realtek nic ?

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
