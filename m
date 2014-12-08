From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 88591] SCSI_IOCTL_GET_IDLUN only returns 8 bits for the SCSI
 Target value
Date: Mon, 08 Dec 2014 21:34:35 +0000
Message-ID: <bug-88591-11613-SubjEadRRY@https.bugzilla.kernel.org/>
References: <bug-88591-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54171 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbaLHVeo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Dec 2014 16:34:44 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CF61E2011D
	for <linux-scsi@vger.kernel.org>; Mon,  8 Dec 2014 21:34:40 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E55312017E
	for <linux-scsi@vger.kernel.org>; Mon,  8 Dec 2014 21:34:39 +0000 (UTC)
In-Reply-To: <bug-88591-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=88591

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk

--- Comment #3 from Alan <alan@lxorguk.ukuu.org.uk> ---
IMHO the ioctl ought to be sorted - it's otherwise hard to fix up existing
code, or to handle platforms that don't use sysfs crap but where you can get
regular pulls/rescans of devices (eg some embedded)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
