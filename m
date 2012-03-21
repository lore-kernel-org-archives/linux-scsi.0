From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42969] Softlockup during boot during init_sd
Date: Wed, 21 Mar 2012 06:48:57 GMT
Message-ID: <201203210648.q2L6mv4T020039@bugzilla.kernel.org>
References: <bug-42969-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:50139 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab2CUGs5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Mar 2012 02:48:57 -0400
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q2L6mvim020040
	for <linux-scsi@vger.kernel.org>; Wed, 21 Mar 2012 06:48:57 GMT
In-Reply-To: <bug-42969-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42969





--- Comment #2 from Eric Sesterhenn <eric.sesterhenn@lsexperts.de>  2012-03-21 06:48:56 ---
Created an attachment (id=72664)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=72664)
Kernel Log from a failing kernel

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
