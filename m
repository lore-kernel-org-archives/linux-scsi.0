From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14214] BUG at drivers/scsi/scsi_lib.c:1108!
Date: Thu, 1 Oct 2009 08:49:54 GMT
Message-ID: <200910010849.n918nsI6006445@demeter.kernel.org>
References: <bug-14214-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41690 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbZJAItu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 04:49:50 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n918nsUt006446
	for <linux-scsi@vger.kernel.org>; Thu, 1 Oct 2009 08:49:54 GMT
In-Reply-To: <bug-14214-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14214





--- Comment #5 from Plamen Petrov <pvp-lsts@fs.ru.acad.bg>  2009-10-01 08:49:52 ---
Created an attachment (id=23217)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=23217)
the .config I used with gcc 4.4

This is the .config I used with 2.6.32-rc1 and gcc 4.4 - this one
is with SMP support ENABLED and so far is working fine, both on the
real and inside the virtual machine.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
