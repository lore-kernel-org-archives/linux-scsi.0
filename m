From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114401] crash dump aic94xx
Date: Thu, 07 Apr 2016 18:29:20 +0000
Message-ID: <bug-114401-11613-c9oEFcGfrr@https.bugzilla.kernel.org/>
References: <bug-114401-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34907 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756577AbcDGS3Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Apr 2016 14:29:24 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D716D201ED
	for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2016 18:29:22 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 243A820212
	for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2016 18:29:21 +0000 (UTC)
In-Reply-To: <bug-114401-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=114401

Bulanov Maxim <bulanovmg@yandex.ru> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
             Status|NEW                         |RESOLVED
         Resolution|---                         |CODE_FIX

--- Comment #2 from Bulanov Maxim <bulanovmg@yandex.ru> ---
Thank you, look like this help me. I not get crash more, just error.

[ 1193.833040] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[ 1193.833047] sas: trying to find task 0xffff8800bb0e7700
[ 1193.833049] sas: sas_scsi_find_task: aborting task 0xffff8800bb0e7700
[ 1193.833153] sas: sas_scsi_find_task: querying task 0xffff8800bb0e7700
[ 1193.833155] sas: sas_scsi_find_task: aborting task 0xffff8800bb0e7700
[ 1193.833247] sas: sas_scsi_find_task: querying task 0xffff8800bb0e7700
[ 1193.833249] sas: sas_scsi_find_task: aborting task 0xffff8800bb0e7700
[ 1193.833350] sas: sas_scsi_find_task: querying task 0xffff8800bb0e7700
[ 1193.833355] sas: sas_scsi_find_task: aborting task 0xffff8800bb0e7700
[ 1193.833456] sas: sas_scsi_find_task: querying task 0xffff8800bb0e7700
[ 1193.833458] sas: sas_scsi_find_task: aborting task 0xffff8800bb0e7700
[ 1193.833554] sas: sas_scsi_find_task: querying task 0xffff8800bb0e7700
[ 1193.833556] sas: task 0xffff8800bb0e7700 is not at LU: I_T recover
[ 1193.833558] sas: I_T nexus reset for dev 5003048000257da6
[ 1194.334256] sas: I_T 5003048000257da6 recovered
[ 1194.334279] sas: ata7: end_device-6:0: dev error handler
[ 1194.334291] sas: ata8: end_device-6:1: dev error handler
[ 1194.334297] sas: ata9: end_device-6:2: dev error handler
[ 1194.334301] sas: ata10: end_device-6:3: dev error handler
[ 1194.334307] sas: ata11: end_device-6:4: dev error handler
[ 1194.334314] sas: ata12: end_device-6:5: dev error handler
[ 1194.334315] sas: ata13: end_device-6:6: dev error handler
[ 1194.334322] sas: ata14: end_device-6:7: dev error handler
[ 1194.334327] ata14.00: retrying FLUSH 0xea Emask 0x0

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
