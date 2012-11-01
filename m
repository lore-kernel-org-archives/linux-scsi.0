From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 49821] Random Call traces when using tape device.
Date: Thu,  1 Nov 2012 16:03:07 +0000 (UTC)
Message-ID: <20121101160307.223C811FB81@bugzilla.kernel.org>
References: <bug-49821-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53521 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933964Ab2KAQDR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Nov 2012 12:03:17 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DA97A20420
	for <linux-scsi@vger.kernel.org>; Thu,  1 Nov 2012 16:03:12 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 3679320427
	for <linux-scsi@vger.kernel.org>; Thu,  1 Nov 2012 16:03:08 +0000 (UTC)
In-Reply-To: <bug-49821-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=49821





--- Comment #4 from Alan <alan@lxorguk.ukuu.org.uk>  2012-11-01 16:03:06 ---
If the Nvidia driver breaks it then you'll need to discuss that with Nvidia -
only they have the source to it. It might be interesting to try it with the
nouveau driver and X server setup with a modern kernel. If that works then
great you've got graphics, if not and you also get IRQ 17 problems it may be a
useful pointer.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
