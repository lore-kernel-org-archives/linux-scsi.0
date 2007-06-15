From: David Miller <davem@davemloft.net>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Fri, 15 Jun 2007 14:19:17 -0700 (PDT)
Message-ID: <20070615.141917.85409547.davem@davemloft.net>
References: <1181918159.25228.543.camel@pmac.infradead.org>
	<Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be>
	<20070615171545.316dfac7@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40823
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbXFOVTO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2007 17:19:14 -0400
In-Reply-To: <20070615171545.316dfac7@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk
Cc: Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org, axboe@kernel.dk, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 15 Jun 2007 17:15:45 +0100

> > > Any particular reason why this is done as a separate block device driver
> > > rather than as SCSI?
> > 
> > Because no new fake SCSI drivers are accepted anymore.
> 
> Where did drivers/ata come from ;)
> 
> How about making it a fake ata driver if James is being fussy 8)

That sounds like a good idea for my virtual I/O case on
Niagara too actually :-)

Another quirk I have to deal with is that under LDOMs you
can export full disks and also just slices.  So I'll have
to get down into the partition machinery to support that
somehow.
