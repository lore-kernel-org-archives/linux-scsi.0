From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42969] Softlockup during boot during init_sd
Date: Wed, 21 Mar 2012 06:50:16 GMT
Message-ID: <201203210650.q2L6oGvu020092@bugzilla.kernel.org>
References: <bug-42969-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:50155 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab2CUGuR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Mar 2012 02:50:17 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2L6oGhH020093
	for <linux-scsi@vger.kernel.org>; Wed, 21 Mar 2012 06:50:16 GMT
In-Reply-To: <bug-42969-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42969





--- Comment #4 from Eric Sesterhenn <eric.sesterhenn@lsexperts.de>  2012-03-21 06:50:16 ---
Created an attachment (id=72666)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=72666)
multipath -ll output

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
