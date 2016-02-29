From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112241] Under heavy load FC TARGET going to Oops
Date: Mon, 29 Feb 2016 02:26:23 +0000
Message-ID: <bug-112241-11613-ZpqrUiCAaU@https.bugzilla.kernel.org/>
References: <bug-112241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39641 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbcB2C01 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Feb 2016 21:26:27 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A674A20263
	for <linux-scsi@vger.kernel.org>; Mon, 29 Feb 2016 02:26:26 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DA60C2027D
	for <linux-scsi@vger.kernel.org>; Mon, 29 Feb 2016 02:26:23 +0000 (UTC)
In-Reply-To: <bug-112241-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=112241

Anthony <anthony.bloodoff@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|4.3.3                       |4.5.0

--- Comment #2 from Anthony <anthony.bloodoff@gmail.com> ---
With kernel 4.5.0 on target, system hang after clients connects to target.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
