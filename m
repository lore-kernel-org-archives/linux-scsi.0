From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Thu, 08 Oct 2015 02:55:56 +0000
Message-ID: <bug-60758-11613-93UfWd3XYw@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39291 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbbJHC4B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Oct 2015 22:56:01 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 244182039E
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2015 02:55:59 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 2728B203EC
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2015 02:55:58 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

Jamie Bainbridge <jamie.bainbridge@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |jamie.bainbridge@gmail.com

--- Comment #60 from Jamie Bainbridge <jamie.bainbridge@gmail.com> ---
This was resolved in dracut with
http://git.kernel.org/cgit/boot/dracut/dracut.git/commit/?id=faa17f09218ed7e2ce4362cc2d9319f8d5b7a37f
which was included in Red Hat's dracut-004-356.el6 package.

This bug can be closed.

-- 
You are receiving this mail because:
You are the assignee for the bug.
