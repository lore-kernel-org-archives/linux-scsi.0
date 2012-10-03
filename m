From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48241] oops when setting up LVM
Date: Wed,  3 Oct 2012 16:45:43 +0000 (UTC)
Message-ID: <20121003164543.B78C511FC43@bugzilla.kernel.org>
References: <bug-48241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:46699 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab2JCQpr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2012 12:45:47 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 4234E204A4
	for <linux-scsi@vger.kernel.org>; Wed,  3 Oct 2012 16:45:46 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 48025204D8
	for <linux-scsi@vger.kernel.org>; Wed,  3 Oct 2012 16:45:45 +0000 (UTC)
In-Reply-To: <bug-48241-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=48241





--- Comment #8 from Daniel Santos <daniel.santos@pobox.com>  2012-10-03 16:45:43 ---
Created an attachment (id=81971)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=81971)
config-3.6.0-next-20121003 (second)

OK, so I took my .config from 3.6.0-vanilla, ran oldconfig under
3.6.0-next-20121003 (using all default answers) and I have the same oops.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
