From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101011] Kernel Oops when disconnecting a mounted ext4 usb stick
Date: Mon, 28 Sep 2015 21:46:44 +0000
Message-ID: <bug-101011-11613-Uz0KPVrfDB@https.bugzilla.kernel.org/>
References: <bug-101011-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60634 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbbI1Vqt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Sep 2015 17:46:49 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E3CFC20755
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2015 21:46:45 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6477520726
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2015 21:46:44 +0000 (UTC)
In-Reply-To: <bug-101011-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=101011

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #12 from Theodore Tso <tytso@mit.edu> ---
The revert is upstream as commit bdfe0cbd746aa9 and will be showing up stable
backport kernels very shortly (the deadline for commenting on the stable
backports is tonight, so the next stable backport kernels should be released
within a day or so with the revert).

It's up to the distribution to update their kernels, and they don't have to
wait for the stable kernel backports to be released.  So please feel free to
request at each of the various distro-specific bug trackers that they include
the revert found in upstream commit bdfe0cbd746aa9.  Especially if you are
receiving paid support from the distribution, they are much more likely to
listen to you.  :-)

-- 
You are receiving this mail because:
You are the assignee for the bug.
