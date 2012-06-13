From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 43359] LVM volumes not detected
Date: Wed, 13 Jun 2012 13:07:50 +0000 (UTC)
Message-ID: <20120613130750.52CD2120610@bugzilla.kernel.org>
References: <bug-43359-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:36502 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab2FMNH5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2012 09:07:57 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E835D20342
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2012 13:07:55 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.204])
	by mail.kernel.org (Postfix) with ESMTP id 41B1120351
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2012 13:07:51 +0000 (UTC)
In-Reply-To: <bug-43359-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=43359


Alan <alan@lxorguk.ukuu.org.uk> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |alan@lxorguk.ukuu.org.uk




--- Comment #2 from Alan <alan@lxorguk.ukuu.org.uk>  2012-06-13 13:07:49 ---
Might be worth attaching a dmesg of both a working and failing boot

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
