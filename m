From: Matthias Andree <ma+lscsi@dt.e-technik.uni-dortmund.de>
Subject: Re: sym53c8xx_2 funkiness...
Date: Mon, 26 Jul 2004 18:18:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040726161825.GA14799@merlin.emma.line.org>
References: <20040718030514.GJ1105@eriador.mirkwood.net> <20040724165625.GA1105@eriador.mirkwood.net> <m3zn5nxi6j.fsf@merlin.emma.line.org> <20040726160214.GB1105@eriador.mirkwood.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:674 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S265887AbUGZQSb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2004 12:18:31 -0400
Received: from m2a2.dyndns.org (p5487CB64.dip.t-dialin.net [84.135.203.100])
	by mail.dt.e-technik.uni-dortmund.de (Postfix) with ESMTP id 0ACA73668C
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2004 18:18:28 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by merlin.emma.line.org (Postfix) with ESMTP id E8DF6C5CE1
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jul 2004 18:18:26 +0200 (CEST)
Received: from merlin.emma.line.org ([127.0.0.1])
 by localhost (m2a2.dyndns.org [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 14794-01 for <linux-scsi@vger.kernel.org>;
 Mon, 26 Jul 2004 18:18:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20040726160214.GB1105@eriador.mirkwood.net>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Mon, 26 Jul 2004, PinkFreud wrote:

> Can one safely disable disconnect if there are multiple devices on the
> bus?  In particular, the system has a hard disk and a cdrom (both
> external - and yes, I tried replacing the cable from the box to the
> drives, and at the moment, I only have the hd plugged in).

It'll cause some quirks, such as the HD not being able to be accessed
while the CD-ROM retries reading a defective sector or while it is
operating its tray to eject or load a disc.

> It's possible I just need to provide some options to the driver - I
> wouldn't be surprised if some defaults have changed to favor newer
> hardware.  I merely need to find out *what* needs changing...

The documentation in the kernel sources (Documentation/scsi/...) is
quite detailed.

-- 
Matthias Andree

Encrypted mail welcome: my GnuPG key ID is 0x052E7D95 (PGP/MIME preferred)
