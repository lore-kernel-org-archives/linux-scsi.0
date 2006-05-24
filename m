From: "Fredrik Lindgren" <fli@swip.net>
Subject: Hotplug problems on MPT Fusion SAS
Date: Wed, 24 May 2006 17:27:12 +0200
Message-ID: <9f16bed6bf0b614496b81a5d22cf8201@swip.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailfe01.swip.net ([212.247.154.1]:44004 "EHLO swip.net")
	by vger.kernel.org with ESMTP id S932335AbWEXP1Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 May 2006 11:27:16 -0400
Received: from [130.244.254.1] (account fli@swip.net)
  by mailbe05.swip.net (CommuniGate Pro IMAP 5.0.9)
  with XMIT id 8907382 for linux-scsi@vger.kernel.org; Wed, 24 May 2006 17:27:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello

I'm having some problems with a the LSI SAS controller in a 
Sun x4200 machine.

I can't get the hotplugging of disks to work. When I boot the machine
with all the disks in place on kernel 2.6.16.16 it find them all right.
But when I remove a drive and reinsert it, this happens:

May 23 16:40:02 localhost kernel: mptsas: remove event for non-existant
PHY.
May 23 16:42:22 localhost kernel: mptsas: add event for non-existant
PHY.

When the drive is removed, the device disappears, but when it's 
reinserted I just the "add event for non-existant PHY." message
and no device appears.

I tried it with kernel 2.6.17-rc4 too, booting the machine and then
inserting the drive. Nothing happens, noting at all. Drives attached
when the machine is booted works great on both kernels. I've been
fooling around with scsiadd too, with no results. But my understanding
is that this shouldn't be needed with SAS?

Are there any known issues with this controller? I haven't been able
to find anything online.

This is what /proc/scsi/mptsas/0 says about the controller:

ioc0: LSISAS1064, FwRev=01040000h, Ports=1, MaxQ=511

Distro is Debian Stable, with our own kernel.

Regards,
  Fredrik Lindgren



