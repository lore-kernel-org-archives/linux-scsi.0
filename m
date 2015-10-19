From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 106261] there exists a wrong return value of function
 asd_map_memio() when ioremap_nocache() fails
Date: Mon, 19 Oct 2015 14:23:56 +0000
Message-ID: <bug-106261-11613-zvVlrPglmA@https.bugzilla.kernel.org/>
References: <bug-106261-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41496 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbbJSOX7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2015 10:23:59 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id BB79F2078B
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2015 14:23:58 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id D7B86205B6
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2015 14:23:57 +0000 (UTC)
In-Reply-To: <bug-106261-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=106261

--- Comment #1 from RUC_Soft_Sec <rucsoftsec@gmail.com> ---
*** Bug 106211 has been marked as a duplicate of this bug. ***

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
