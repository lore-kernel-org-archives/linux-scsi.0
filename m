From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: suspending I/Os to a device
Date: Fri, 23 Jul 2004 00:36:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <410095B3.8060902@optonline.net>
References: <3356669BBE90C448AD4645C843E2BF28025AB79F@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta10.srv.hcvlny.cv.net ([167.206.5.85]:3265 "EHLO
	mta10.srv.hcvlny.cv.net") by vger.kernel.org with ESMTP
	id S262085AbUGWEgD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2004 00:36:03 -0400
Received: from optonline.net (ool-43564880.dyn.optonline.net [67.86.72.128])
 by mta10.srv.hcvlny.cv.net
 (iPlanet Messaging Server 5.2 HotFix 1.25 (built Mar  3 2004))
 with ESMTP id <0I1A00318FG37A@mta10.srv.hcvlny.cv.net> for
 linux-scsi@vger.kernel.org; Fri, 23 Jul 2004 00:36:03 -0400 (EDT)
In-reply-to: <3356669BBE90C448AD4645C843E2BF28025AB79F@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Ely, Paul" <Paul.Ely@Emulex.Com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "Smart, James" <James.Smart@Emulex.Com>, 'James Bottomley' <James.Bottomley@steeleye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

Ely, Paul wrote:

>All,
>
>
>The following patch provides an implementation of
>the proposal contained in this mail thread.  The
>patch does not provide a complete solution such
>as:
>	nodevice tmo handling by the scsi midlayer
>	scsi_device structure member for nodevice tmo
>	handling of SDEV_SUSPEND state by midlayer
>
>Subsequent patches to address remaining implementation.
>
I'm a little late to the party. Is this intended to facilitate the PCI 
power management (queue quiesce) issues that were discussed this week? 
Will it be sufficient to "just call" these from pcidev->suspend(), 
pcidev->resume()?

Duh, like thanks and stuff. I think.
Nathan
