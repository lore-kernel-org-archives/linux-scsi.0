From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 48241] oops when setting up LVM
Date: Wed,  3 Oct 2012 16:16:49 +0000 (UTC)
Message-ID: <20121003161649.2189B11FC43@bugzilla.kernel.org>
References: <bug-48241-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45763 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964854Ab2JCQQy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2012 12:16:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 53B90204F3
	for <linux-scsi@vger.kernel.org>; Wed,  3 Oct 2012 16:16:52 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 76544204EF
	for <linux-scsi@vger.kernel.org>; Wed,  3 Oct 2012 16:16:50 +0000 (UTC)
In-Reply-To: <bug-48241-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=48241





--- Comment #6 from Daniel Santos <daniel.santos@pobox.com>  2012-10-03 16:16:48 ---
Created an attachment (id=81951)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=81951)
oops of next-20121003 compiled with gcc 4.6.3

So yeah, very similar oops under 4.6.3 (looks like all that changed were
addresses & such).  I'm running 3.6.0 right now.

uugh, but now that I think about it, I didn't use the same config that I was
running earlier since oldconfig was asking me tons of questions that were
already answered with a previous config (options removed or moved possibly?). 
To make this complete, I should use my current 3.6.0 config, rebase to
next-20121003 and build that.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
