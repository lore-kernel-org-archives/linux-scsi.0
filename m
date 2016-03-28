From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 115351] redundant pointless messages
Date: Mon, 28 Mar 2016 01:14:41 +0000
Message-ID: <bug-115351-11613-L3Z2rev49w@https.bugzilla.kernel.org/>
References: <bug-115351-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39598 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbcC1BOq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Mar 2016 21:14:46 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A901D20211
	for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2016 01:14:44 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id BD56C2021F
	for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2016 01:14:41 +0000 (UTC)
In-Reply-To: <bug-115351-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=115351

--- Comment #2 from Jonathan <spamme@ecybernard.com> ---
clearly if 16 is enough for 2^64 then just get rid of the error message all
together, and call it done.

I don't know why sd_try_rc16_first() returns zero.
I don't even know how to find out.

This is all the dmesg reveals:
[    2.520235] AAC0: kernel 7.5-0[32084] Jun 15 2015
[    2.520240] AAC0: monitor 7.5-0[32084]
[    2.520241] AAC0: bios 7.5-0[32084]
[    2.520243] AAC0: serial ########
[    2.520244] AAC0: Non-DASD support enabled.
[    2.520246] AAC0: 64bit support enabled.
[    2.520247] AAC0: 64 Bit DAC enabled
[    2.520524] scsi host4: aacraid
[    2.530234] scsi host5: pata_atiixp
[    2.530480] scsi 4:0:0:0: Direct-Access     ASR7168  Tardis           V1.0
PQ: 0 ANSI: 2
[    2.530631] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[    2.530687] sd 4:0:0:0: [sdc] 19503493120 512-byte logical blocks: (9.99
TB/9.08 TiB)
[    2.530697] sd 4:0:0:0: [sdc] Write Protect is off
[    2.530699] sd 4:0:0:0: [sdc] Mode Sense: 12 00 10 08
[    2.530706] sd 4:0:0:0: Attached scsi generic sg2 type 0
[    2.530730] sd 4:0:0:0: [sdc] Write cache: disabled, read cache: enabled,
supports DPO and FUA
[    2.530891] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).
[    2.531195] sd 4:0:0:0: [sdc] Very big device. Trying to use READ
CAPACITY(16).

-- 
You are receiving this mail because:
You are the assignee for the bug.
