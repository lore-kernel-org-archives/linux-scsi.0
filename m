From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42765] mptscsih driver issues task aborts during high write
 utilization
Date: Tue, 14 Feb 2012 14:57:39 GMT
Message-ID: <201202141457.q1EEvdPE015030@bugzilla.kernel.org>
References: <bug-42765-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:56687 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2BNO5j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2012 09:57:39 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q1EEvdul015031
	for <linux-scsi@vger.kernel.org>; Tue, 14 Feb 2012 14:57:39 GMT
In-Reply-To: <bug-42765-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=42765





--- Comment #1 from Eric <eric.hidle@gmail.com>  2012-02-14 14:57:38 ---
Created an attachment (id=72375)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=72375)
TGZ file with patched mptsas driver for ESXi 5.0

This is a TGZ file designed to be used with the ESXi Customizer v2.5 or v2.6 to
patch a new mptsas driver into the stock ESXi 5.0 installation CD. I recompiled
the community source driver to incorporate the patch against this driver that
was introduced in Linux 2.6.35 that is not present in the ESXi 5.0 driver. 

I did this because I suspect this problem is being caused by ESXi, and not the
Linux Guest. I will follow up once I have been able to test this new driver on
an ESXi installation.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
