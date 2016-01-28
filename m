From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111381] mvsas 0.8.16 on Marvell 88SE9485 reports timeouts on
 load
Date: Thu, 28 Jan 2016 00:37:56 +0000
Message-ID: <bug-111381-11613-BgE3qAkv3w@https.bugzilla.kernel.org/>
References: <bug-111381-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52145 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965258AbcA1Ah7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 19:37:59 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0ED8D20295
	for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 00:37:58 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id AE42E20251
	for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 00:37:56 +0000 (UTC)
In-Reply-To: <bug-111381-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111381

--- Comment #2 from Gabriel A. Devenyi <gdevenyi@gmail.com> ---
After a check and reseat of all cables, now getting this in dmesg:
[ 4386.920825] sd 3:0:4:0: [sdn] tag#0 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[ 4386.920834] sd 3:0:4:0: [sdn] tag#0 Sense Key : Aborted Command [current] [
4386.920841] sd 3:0:4:0: [sdn] tag#0 ASC=0x4b ASCQ=0x20
[ 4386.920847] sd 3:0:4:0: [sdn] tag#0 CDB: Read(10) 28 00 33 03 4f bf 00 00 25
00
[ 4386.920852] blk_update_request: I/O error, dev sdn, sector 855855039

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
