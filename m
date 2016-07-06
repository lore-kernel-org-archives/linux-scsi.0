From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 121531] Adaptec 7805H SAS HBA (pm80xx): hangs when writing
 >80MB at once
Date: Wed, 06 Jul 2016 15:47:28 +0000
Message-ID: <bug-121531-11613-yzqv7GLLjD@https.bugzilla.kernel.org/>
References: <bug-121531-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:46718 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbcGFPrb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jul 2016 11:47:31 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A03E720149
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2016 15:47:30 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 4031A20142
	for <linux-scsi@vger.kernel.org>; Wed,  6 Jul 2016 15:47:29 +0000 (UTC)
In-Reply-To: <bug-121531-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=121531

--- Comment #7 from Martin von Wittich <martin.von.wittich@iserv.eu> ---
Created attachment 222241
  --> https://bugzilla.kernel.org/attachment.cgi?id=222241&action=edit
dmesg output after booting, before writing to the disks

-- 
You are receiving this mail because:
You are the assignee for the bug.
