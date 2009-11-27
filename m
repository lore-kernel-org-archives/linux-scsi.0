From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13783] udev causes high cpu usage
Date: Fri, 27 Nov 2009 09:52:00 GMT
Message-ID: <200911270952.nAR9q0lS007448@demeter.kernel.org>
References: <bug-13783-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56751 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbZK0Jvx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Nov 2009 04:51:53 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAR9q02a007449
	for <linux-scsi@vger.kernel.org>; Fri, 27 Nov 2009 09:52:00 GMT
In-Reply-To: <bug-13783-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13783





--- Comment #23 from Petr Stehlik <pstehlik@sophics.cz>  2009-11-27 09:51:53 ---
I have tried some PPA build of udev-147~-6.2 but it didn't help either. What
can I do to get this fixed? 55% CPU load is not fun. Thanks.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
