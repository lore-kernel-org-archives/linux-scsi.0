From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60644] MPT2SAS drops all HDDs when under high I/O
Date: Tue, 29 Mar 2016 15:02:45 +0000
Message-ID: <bug-60644-11613-kfACOKIgZc@https.bugzilla.kernel.org/>
References: <bug-60644-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59978 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322AbcC2PCu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2016 11:02:50 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id E702220103
	for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2016 15:02:47 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 1A34720340
	for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2016 15:02:47 +0000 (UTC)
In-Reply-To: <bug-60644-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60644

rlung_74@yahoo.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |rlung_74@yahoo.com

--- Comment #49 from rlung_74@yahoo.com ---
(In reply to Jeff Johnson from comment #48)
> Awesome! I'm glad it is working for others.

Disabling ASPM did the trick for me!  

Always hanged within 20min under heavy IO before disabling ASPM. 

On Supermicro x10sl7 its under advanced, chipset config, system agent config,
pcie config

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
