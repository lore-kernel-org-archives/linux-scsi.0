From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Wed, 18 Nov 2009 15:37:50 GMT
Message-ID: <200911181537.nAIFbo7O008567@demeter.kernel.org>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57920 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbZKRPho (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 10:37:44 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nAIFbokv008568
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2009 15:37:50 GMT
In-Reply-To: <bug-14563-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=14563





--- Comment #12 from Joachim Breuer <linux-kernel@jmbreuer.net>  2009-11-18 15:37:50 ---
I'll attach the console log of a working dump to tape (roughly 11 GB in several
(tape) files) below.

After that, I'll try with 'try_rdi0=0 try_wdio=0'.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
