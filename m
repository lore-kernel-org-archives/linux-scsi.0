From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121531] Adaptec 7805H SAS HBA (pm80xx): hangs when writing
 >80MB at once
Date: Wed, 06 Jul 2016 15:48:04 +0000
Message-ID: <bug-121531-11613-M9XdYxll9l@https.bugzilla.kernel.org/>
References: <bug-121531-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46772 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbcGFPsI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jul 2016 11:48:08 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 22E1C2013D
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2016 15:48:07 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 9074D20142
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2016 15:48:04 +0000 (UTC)
In-Reply-To: <bug-121531-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=121531

--- Comment #8 from Martin von Wittich <martin.von.wittich@iserv.eu> ---
Created attachment 222251
  --> https://bugzilla.kernel.org/attachment.cgi?id=222251&action=edit
dmesg output a few seconds after writing >128 MB to one disk

-- 
You are receiving this mail because:
You are the assignee for the bug.
