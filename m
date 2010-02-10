From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14579] Devices disappear; on bus reset machine hangs; on I/O
 machine hangs
Date: Wed, 10 Feb 2010 10:11:21 GMT
Message-ID: <201002101011.o1AABLK8011867@demeter.kernel.org>
References: <bug-14579-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:41069 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab0BJKLW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2010 05:11:22 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1AABLoh011881
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Feb 2010 10:11:21 GMT
In-Reply-To: <bug-14579-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14579





--- Comment #7 from lkolbe@techfak.uni-bielefeld.de  2010-02-10 10:10:46 ---
As it turned out this machine was faulty (all 24 disks began dematerializing
under our feet) so we replaced it. We do now face similar issues, though I'll
open a new bug for that one to have a clear separation. Whoever has the
permission to close this bug might do so, please.

Kind regards, 
Lukas

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
