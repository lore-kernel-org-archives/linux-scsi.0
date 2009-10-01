From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14214] BUG at drivers/scsi/scsi_lib.c:1108!
Date: Thu, 1 Oct 2009 09:35:56 GMT
Message-ID: <200910010935.n919ZuZQ011104@demeter.kernel.org>
References: <bug-14214-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33435 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbZJAJfw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 05:35:52 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n919Zuwo011105
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2009 09:35:56 GMT
In-Reply-To: <bug-14214-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14214





--- Comment #8 from Plamen Petrov <pvp-lsts@fs.ru.acad.bg>  2009-10-01 09:35:55 ---
Well, I don't know what was wrong with 2.6.31-git12, but using the .config in
the first attachment, I ran "make oldconfig && make" with 2.6.32-rc1 - which
produced the .config in the fourth attachment, and a kernel which reboots and
shuts down without problems...

Maybe I should use the gcc I used with the bad .config - for the last test
I used gcc 4.4, from CRUX 2.6, and the bad kernel used gcc 4.3.3...

When I have the time - I will just go ahead and do that.

In the mean time - suggestions, anyone?

Thanks!

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
