From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42765] mptscsih driver issues task aborts during high write
 utilization
Date: Tue, 14 Feb 2012 18:48:10 GMT
Message-ID: <201202141848.q1EImAst019917@bugzilla.kernel.org>
References: <bug-42765-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:57079 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab2BNSsL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2012 13:48:11 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1EImAXP019918
	for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2012 18:48:10 GMT
In-Reply-To: <bug-42765-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42765





--- Comment #2 from Eric <eric.hidle@gmail.com>  2012-02-14 18:48:10 ---
Created an attachment (id=72380)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=72380)
Patched VIB. The tgz I added will not work

I am adding this VIB since a TGZ cannot be used to replace an existing driver
in the ISO. This VIB can be added to the ISO using the Customizer, or be added
to a running system using CLI tools.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
