From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16275] Kernel panic when mounting filesystem
Date: Sat, 24 Jul 2010 10:20:22 GMT
Message-ID: <201007241020.o6OAKMDu032048@demeter.kernel.org>
References: <bug-16275-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:55072 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab0GXKUX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Jul 2010 06:20:23 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6OAKM7v032049
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 24 Jul 2010 10:20:22 GMT
In-Reply-To: <bug-16275-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16275





--- Comment #20 from Pawel Staszewski <pstaszewski@artcom.pl>  2010-07-24 10:20:16 ---
I think this needs a little more work than replacing 'bool' with 'unsigned
long'.
I made this and also have panic.

Sorry for no trace output but i forget to catch console - and also have hard
access to this machine.

Thanks
Pawel

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
