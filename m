From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42969] Softlockup during boot during init_sd
Date: Wed, 25 Apr 2012 14:39:10 GMT
Message-ID: <201204251439.q3PEdA7s017211@bugzilla.kernel.org>
References: <bug-42969-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:58275 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2DYOjL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2012 10:39:11 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q3PEdAtU017212
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2012 14:39:10 GMT
In-Reply-To: <bug-42969-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42969





--- Comment #6 from Eric Sesterhenn <eric.sesterhenn@lsexperts.de>  2012-04-25 14:39:09 ---
Hi,

is there any additional information I can provide here? This really troubles
us, since this means that only one of four boots succeed and the other three
need a manual restart.

Regards, Eric

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
