From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Announce] Emulex lpfcdriver v8.0.12 available
Date: Tue, 21 Sep 2004 13:40:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921134008.A22816@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C02F1C6@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:27663 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267664AbUIUMkO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 08:40:14 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F1C6@xbl3.ma.emulex.com>; from James.Smart@Emulex.Com on Mon, Sep 20, 2004 at 09:34:27PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

> - Started to add management interfaces (used to be ioctls) to sysfs. This is a WIP and quite a few things are expected to ultimately be moved to the fc transport under a separate RFC/patch.

I don't like many of the binary attributes at all.  As a general rule of
thumb never ever use a binary sysfs attribute unless it's passed through to
the hardware.

For slimreg and ctlreg that is true, but I wonder whether they're needed
at all.  Check how recent X servers access mmio space.

The sendrnid and ctpass ones looks extremly fishy, it's certainly not a
single value that's read/written, and it's deeply magic (and btw,
current->pid is not uniqueue in a multithreaded enviroment)


