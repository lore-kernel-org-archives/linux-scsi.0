From: Alba Pompeo <albapompeo@gmail.com>
Subject: CD media burnt using TAO mode fails to boot
Date: Thu, 9 Jun 2016 09:14:39 -0300
Message-ID: <CAJDAfTCoLLBiOfcK+ws5wOUvg+4QkAppH_s3D7r+1rdyRoKV=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:36494 "EHLO
	mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbcFIMOl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2016 08:14:41 -0400
Received: by mail-vk0-f50.google.com with SMTP id g67so51894310vkb.3
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jun 2016 05:14:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, scdbackup@gmx.net

Hello,

there is a recurrent problem bug in the kernel that makes a CD-R fail
to boot when burnt in TAO mode.

[    9.698776] sr 1:0:0:0: [sr0] tag#12 UNKNOWN(0x2003) Result:
hostbyte=0x00 driverbyte=0x08
[    9.698784] sr 1:0:0:0: [sr0] tag#12 Sense Key : 0x4 [current]
[    9.698788] sr 1:0:0:0: [sr0] tag#12 ASC=0x3e ASCQ=0x2
[    9.698795] sr 1:0:0:0: [sr0] tag#12 CDB: opcode=0x28 28 00 00 00
ae 96 00 00 02 00
[    9.698798] blk_update_request: I/O error, dev sr0, sector 178776

My best guess would be that this confuses the entity among the ISO
payload, which is in charge for creating /dev/disk/by-label/ links
while the system boots up.

I posted about this on bugzilla too -
https://bugzilla.kernel.org/show_bug.cgi?id=118621

If any more information is needed, let me know.
Thank you.
