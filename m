From: Caspar Smit <c.smit@truebit.nl>
Subject: mptsas driver instability?
Date: Mon, 10 Jan 2011 16:01:23 +0100
Message-ID: <AANLkTiku4oOmAmkrzqouO2FkvMpLuQWTw7HpBqri8GpA@mail.gmail.com>
References: <AANLkTinaAPKNb7Mw5=vxJ6aapY5G3Dk-R6Vr1rAx2G6d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57138 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab1AJPBZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jan 2011 10:01:25 -0500
Received: by qyj19 with SMTP id 19so1744164qyj.19
        for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2011 07:01:24 -0800 (PST)
In-Reply-To: <AANLkTinaAPKNb7Mw5=vxJ6aapY5G3Dk-R6Vr1rAx2G6d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I recently switched the sas controller of one of my machines to a LSI
SAS 3081E-R (LSI 1068E Chipset, mptsas driver)

I flashed the controller with the latest BIOS and firmware (IT)
versions from the LSI website (BIOS 6.32.00.00, FW:1.31.00.00)

The machine is running Debian Linux Lenny 5.0 (latest 2.6.26-2-amd64 kernel)
This kernel has the mptsas driver at version 3.04.06

After a weekend of testruns (creating a raidset, filesystems tests and
performance tests) there suddenly dropped a disk from one of the md's

with the following error:

[260824.590033] end_request: I/O error, dev sdv, sector 3907028992
[260824.590111] md: super_written gets error=-5, uptodate=0
[260824.590184] raid5: Disk failure on sdv, disabling device.
[260824.590186] raid5: Operation continuing on 5 devices.

After inspecting the disk on smart errors i couldn't find any errors.

I had the same problem on another system running the lenny-backports
kernel 2.6.32-bpo.5-amd64 (mptsas version 3.04.12) but since the disk
there completely vanished from the kernel
I don't know if this was really a disk problem or not.

I read a thread to the mailinglist about this driver and there was
stated that driver version 3.04.15 should be used.
I saw that the latest version of the driver is 3.04.17 (in the 2.6.37 source)

I'd like to avoid using a non-debian kernel so my question, is it
possible to use the latest driver in the 2.6.26 and/or 2.6.32 debian
kernel?

If so, how would I compile this into the kernel?

Kind regards,

Caspar Smit
