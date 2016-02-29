From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Subject: small diff in reported GiB size of an SSD
Date: Mon, 29 Feb 2016 13:31:44 +0000
Message-ID: <56D44840.5080405@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57358 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133AbcB2Nbu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Feb 2016 08:31:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>

I'm just curious about this diff in dmesg output between 4.3.2 and 4.3.3 at a 64 bit Gentoo hardened system:

$ diff dmesg-4.4.[23]-hardened | grep logical
< sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (240 GB/223 GiB)
> sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (240 GB/224 GiB)

-- 
Toralf
PGP: C4EACDDE 0076E94E, OTR: 420E74C8 30246EE7
