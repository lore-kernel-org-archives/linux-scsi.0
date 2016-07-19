From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 120371] UBSAN splat in drivers/scsi/scsi_devinfo.c:458:21
Date: Tue, 19 Jul 2016 09:54:02 +0000
Message-ID: <bug-120371-11613-SNces8WOHV@https.bugzilla.kernel.org/>
References: <bug-120371-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36366 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbcGSJyG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 05:54:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2338D2024D
	for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2016 09:54:05 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 53E092024C
	for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2016 09:54:03 +0000 (UTC)
In-Reply-To: <bug-120371-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=120371

Navin <navinp1912@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |navinp1912@gmail.com

--- Comment #1 from Navin <navinp1912@gmail.com> ---
This is fixed by commit 5e7ff2ca7f2da55fe777167849d0c93403bd0dc8

-- 
You are receiving this mail because:
You are the assignee for the bug.
