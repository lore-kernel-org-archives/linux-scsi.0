From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 51881] HighPoint RocketRAID 2720 fail to detect some SATA hdd
Date: Sat, 29 Dec 2012 00:06:31 +0000 (UTC)
Message-ID: <20121229000631.3617F11FBAA@bugzilla.kernel.org>
References: <bug-51881-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37159 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075Ab2L2AGf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Dec 2012 19:06:35 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 2E7D620254
	for <linux-scsi@vger.kernel.org>; Sat, 29 Dec 2012 00:06:34 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id C243E20240
	for <linux-scsi@vger.kernel.org>; Sat, 29 Dec 2012 00:06:31 +0000 (UTC)
In-Reply-To: <bug-51881-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=51881


Bohdan Popovych <bohdan@popovych.info> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bohdan@popovych.info




--- Comment #7 from Bohdan Popovych <bohdan@popovych.info>  2012-12-29 00:06:30 ---
I can confirm patch works for me with
- HighPoint RocketRAID 2720
and 
- LSI Logic / Symbios Logic SAS2008 (Falcon)) using mpt2sas
as well on 3.7.1.
Thanks!

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
