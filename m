From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43191] Syslog fills with messages about assuming drive cache
 when SD card not present
Date: Tue,  8 May 2012 09:00:27 +0000 (UTC)
Message-ID: <20120509170415.24F2011FCDE@bugzilla.kernel.org>
References: <bug-43191-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58086 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757560Ab2EIREs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 May 2012 13:04:48 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9F6782024E
	for <linux-scsi@vger.kernel.org>; Wed,  9 May 2012 17:04:44 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id B3C7020272
	for <linux-scsi@vger.kernel.org>; Wed,  9 May 2012 17:04:35 +0000 (UTC)
In-Reply-To: <bug-43191-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=43191





--- Comment #8 from Petr Pisar <petr.pisar@atlas.cz>  2012-05-08 09:00:27 ---
See <https://bugzilla.redhat.com/show_bug.cgi?id=769747> for other
udev---kernel debugging.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
