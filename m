From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Wed, 28 Aug 2013 08:44:31 +0000
Message-ID: <bug-60644-11613-8tStwJxFSa@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42422 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab3H1Iou (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Aug 2013 04:44:50 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A4DE62041D
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2013 08:44:44 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A047620430
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2013 08:44:38 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

Bernd Schubert <bernd.schubert@fastmail.fm> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |bernd.schubert@fastmail.fm

--- Comment #25 from Bernd Schubert <bernd.schubert@fastmail.fm> ---
Have you already tried to give the controller less work, i.e. by setting
/sys/block/sdX/device/queue_depth to 1? If you can't set it, use the mpt2sas
option max_queue_depth=1. A low value of max_sgl_entries and max_sectors also
might help. Lowering all of that is not good for performance, but might
increase stability.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
