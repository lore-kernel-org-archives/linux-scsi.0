From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Tue, 27 Aug 2013 11:45:28 +0000
Message-ID: <bug-60644-11613-OlL1vT3hgl@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:33642 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab3H0Lpd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 07:45:33 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 1509820512
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2013 11:45:32 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id EB7632050C
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2013 11:45:30 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

Hannes Reinecke <hare@suse.de> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |hare@suse.de

--- Comment #20 from Hannes Reinecke <hare@suse.de> ---
Created attachment 107333
  --> https://bugzilla.kernel.org/attachment.cgi?id=107333&action=edit
mpt2sas-disable-watchdog.patch

mpt2sas: add module option to disable watchdog.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
