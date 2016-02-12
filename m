From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111731] mpt2sas doesn't get built
Date: Fri, 12 Feb 2016 05:04:01 +0000
Message-ID: <bug-111731-11613-MG6sHDe6Nk@https.bugzilla.kernel.org/>
References: <bug-111731-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40706 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbcBLFEF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Feb 2016 00:04:05 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A92E5203C4
	for <linux-scsi@vger.kernel.org>; Fri, 12 Feb 2016 05:04:03 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B9B71203B7
	for <linux-scsi@vger.kernel.org>; Fri, 12 Feb 2016 05:04:02 +0000 (UTC)
In-Reply-To: <bug-111731-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111731

biosehn@yahoo.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |biosehn@yahoo.com

--- Comment #1 from biosehn@yahoo.com ---
This related OpenSUSE bugzilla has a patch that resolves the issue. 
https://bugzilla.opensuse.org/show_bug.cgi?id=962694

Per that BZ patch has been sent upstream, so hopefully it will make it into
distributions soon but you can probably solve it manually with that patch to
dracut until dracut itself receives an official update with the patch.

The patch as listed for OpenSUSE doesn't match the line numbers for me on
CentOS7, but searching for the proceeding lines I was able to find where to
patch it manually and it worked, I now have mpt3sas built into my 4.4 initrd
(whereas previously I didn't have either mpt3sas or mpt2sas because my 3.10
only had mpt2sas).

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
