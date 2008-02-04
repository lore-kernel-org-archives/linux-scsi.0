From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch] pci: pci_enable_device_bars() fix
Date: Mon, 04 Feb 2008 10:32:19 -0500
Message-ID: <47A73003.8050100@garzik.org>
References: <20080201231147.GA18174@suse.de>	<20080202111322.GA30767@elte.hu>	<47A49171.2000003@garzik.org>	<20080202170828.GA12748@elte.hu>	<47A4A96D.2040709@garzik.org>	<20080202175738.GA26560@elte.hu>	<47A4BB3C.6050709@garzik.org>	<20080202193524.GC27927@elte.hu>	<47A4D71F.3060009@garzik.org>	<20080204125736.GA32056@elte.hu> <20080204051230.70d5b735.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:46379 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885AbYBDPc0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Feb 2008 10:32:26 -0500
In-Reply-To: <20080204051230.70d5b735.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, pcihpd-discuss@lists.sourceforge.net, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

Andrew Morton wrote:
> Actually I (and probably others) generally avoid cc'ing mailing lists on
> patch traffic.  I spew out enough script-generated traffic as it is.

You pretty much always ensure the driver author gets CC'd, which is 
exemplary :)

	Jeff



