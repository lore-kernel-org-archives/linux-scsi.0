From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH 1/2] SCSI: Add a SCSI option for persistent device names
 in Kernel.
Date: Mon, 18 Apr 2011 15:10:08 -0500
Message-ID: <4DAC9AA0.8090904@tributary.com>
References: <20110405124946.7969.66796.stgit@ltc233.sdl.hitachi.co.jp>	<20110405161400.GA885@kroah.com>	<4D9F17DF.5030601@hitachi.com> <20110408192113.2f3d5eda@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.51]:42554 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab1DRUPf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2011 16:15:35 -0400
In-Reply-To: <20110408192113.2f3d5eda@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Nao Nishijima <nao.nishijima.xt@hitachi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> Identifiers and names of target ports and of logical units (per SAM-2 and
> later, Annex A) --- whether they are persistent, in which scope they are
> unique, how they look like, and how they can be obtained --- are transport
> specific.
> 
> Neither the INQUIRY command (per SPC) nor any other command is generally
> useful to obtain e.g. logical unit identifiers.  Any tool that needs to
> obtain identifiers or names of target ports and of logical units must talk
> with the transport driver through driver-specific interfaces.


	Inquiry page 0x83 has been mandatory for a while now, and while the name/id
assignments are all over the place, it is getting better. Page 0x80 is also
supported on nearly every device manufactured in the last 10 years. Parsing a
few common cases covers the majority of the devices. Of course, the returned
information may not be helpful (even when supported), but we are mostly just
talking about messages being displayed to the user. Some of this information is
already being stored in the kernel, printing something like "s[dgt]X
(man/model/serial/portinfo)" instead of just a "sda" via sd_printk/etc would
probably be quite helpful in a lot of situations.

	Finally, printing this information provides encouragement to the device
manufactures to make sure its available and correct.






	
