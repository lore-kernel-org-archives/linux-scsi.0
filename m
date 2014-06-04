From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 1898] fdomain module crashes on load in 2.6.x
Date: Wed, 04 Jun 2014 02:23:16 +0000
Message-ID: <bug-1898-11613-ZzPjC7Kz0L@https.bugzilla.kernel.org/>
References: <bug-1898-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46297 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718AbaFDCXS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2014 22:23:18 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A7E0F202DD
	for <linux-scsi@vger.kernel.org>; Wed,  4 Jun 2014 02:23:17 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id AF1E8202D1
	for <linux-scsi@vger.kernel.org>; Wed,  4 Jun 2014 02:23:16 +0000 (UTC)
In-Reply-To: <bug-1898-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=1898

--- Comment #5 from Andreas Hartmetz <ahartmetz@web.de> ---
Yeah, that was me clicking the wrong button. If you read from the second
"[PATCH] fdomain screwup", you have the proper commit message.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
