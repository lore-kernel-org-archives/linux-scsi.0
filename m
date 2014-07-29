From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 79901] [BISECTED]Extremely slow boot on Promise VTrak E610f due
 to sd_mod RSOC usage
Date: Tue, 29 Jul 2014 20:26:58 +0000
Message-ID: <bug-79901-11613-V8SiOZNdl9@https.bugzilla.kernel.org/>
References: <bug-79901-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43667 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbaG2U1C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2014 16:27:02 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4B51C20127
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2014 20:27:01 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 495FE2017D
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2014 20:26:59 +0000 (UTC)
In-Reply-To: <bug-79901-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=79901

Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
         Regression|No                          |Yes

-- 
You are receiving this mail because:
You are the assignee for the bug.
