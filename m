From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13242] System Panics with emulex lpfc driver during the boot
Date: Wed, 6 May 2009 23:40:37 GMT
Message-ID: <200905062340.n46Neb7A015374@demeter.kernel.org>
References: <bug-13242-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34693 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbZEFXkg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2009 19:40:36 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n46Nebqu015375
	for <linux-scsi@vger.kernel.org>; Wed, 6 May 2009 23:40:37 GMT
In-Reply-To: <bug-13242-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13242





--- Comment #4 from Babu Moger <babu.moger@lsi.com>  2009-05-06 23:40:36 ---
Yes, You are right..  It is fixed with the attached patch..(8.3.1).
Thanks for  looking into the problem.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
