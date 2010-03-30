From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12544] megaraid kernel oops during smartd poll
Date: Tue, 30 Mar 2010 18:56:01 GMT
Message-ID: <201003301856.o2UIu1ga023218@demeter.kernel.org>
References: <bug-12544-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:33670 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab0C3S4F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2010 14:56:05 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2UIu1Cs023219
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 30 Mar 2010 18:56:01 GMT
In-Reply-To: <bug-12544-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=12544





--- Comment #4 from Roland Kletzing <devzero@web.de>  2010-03-30 18:55:57 ---
i did not yet have a chance to check if this one fixes the problem:

https://bugzillafiles.novell.org/attachment.cgi?id=351428

maybe you want to give it a try....

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
