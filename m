From: Andries Brouwer <Andries.Brouwer@cwi.nl>
Subject: Re: [usb-storage] Re: Handling erroneous READ CAPACITY response in sd.c
Date: Fri, 5 Nov 2004 22:59:37 +0100
Message-ID: <20041105215935.GD10912@apps.cwi.nl>
References: <20041105184402.GB10912@apps.cwi.nl> <Pine.LNX.4.44L0.0411051632440.1015-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:2734 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S261221AbUKEV7n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2004 16:59:43 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0411051632440.1015-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andries Brouwer <Andries.Brouwer@cwi.nl>, Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Fri, Nov 05, 2004 at 04:38:07PM -0500, Alan Stern wrote:

> No.  I said that it _could_ be moved to a SCSI blist but would probably be
> better off remaining in unusual_devices.  What should be changed is the
> way we handle these devices.  Right now usb-storage alters the data sent
> by the device, before anyone else can see it.  My proposal is that
> usb-storage pass the data unchanged and sd_read_capacity() change the
> value it gets if the device is known to be bad.

OK - yes, I agree.

Andries
