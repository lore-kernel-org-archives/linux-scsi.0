From: Patrick Nagel <mail@patrick-nagel.net>
Subject: Re: 2.6.39: Semi-reproducible panic when inserting usb stick
Date: Mon, 30 May 2011 04:16:15 +0000 (UTC)
Message-ID: <loom.20110530T061447-377@post.gmane.org>
References: <20110529003726.62d0af31@loki.alfsgard.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:47496 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab1E3EUH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2011 00:20:07 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1QQtxV-0003N2-Kt
	for linux-scsi@vger.kernel.org; Mon, 30 May 2011 06:20:06 +0200
Received: from 58.246.134.210 ([58.246.134.210])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2011 06:20:05 +0200
Received: from mail by 58.246.134.210 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2011 06:20:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Peter Alfredsen writes:
> I get the attached panic when inserting my Sandisk Cruzer USB stick.
> This system is a new build and I got the panic on first insertion. Also
> find attached .config and dmesg from a normal start.
> 
> I can reproduce by inserting the stick enough times -- eventually it
> will panic. It makes no difference which port I use.

I get a panic that looks very similar to this one, when I plug in various USB
devices (an Android phone, a portable video player, a portable HDD).
I also get panics when booting while USB devices are attached (the system only
boots every 5th time or so, so it's quite reproducible). The panic usually
occurs around the time when the Gentoo init process shows "Waiting for uevents
to be processed ...".

This is on both my Atom netbook and AMD Phenom desktop, both running
2.6.39-gentoo, using various cables and various USB ports.

Both systems run perfectly stable once the device got plugged in and no panic
occurred, also transferring data via USB is no problem.

How can I help to get this problem resolved?

Patrick.

