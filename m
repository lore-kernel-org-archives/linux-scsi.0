From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: 29 Sep 2003 08:54:41 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064847281.24854.2.camel@patehci2>
References: <1064271322.4797.9.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:13019 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263489AbTI2Oy0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 10:54:26 -0400
In-Reply-To: <1064271322.4797.9.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-usb-devel@vger.kernel.org, torvalds@osdl.org, mdharm-scsi@one-eyed-alien.net, stern@rowland.harvard.edu, hch@infradead.org, james.bottomley@steeleye.com, andries.brouwer@cwi.nl


> From: Linus Torvalds <torvalds () osdl ! org>
> Date: 2003-09-23 15:46:21
>
> Normal users consider hot-pluggable
> to be "I can rip the thing out by hand".

Yes.

Meanwhile, much (all except flash?) actual usb-storage now commercially
available is Not hot-pluggable in this sense.  Instead, "ata hdd lose
data in response to a pin 1 reset issued without op x35
"SYNCHRONIZE_CACHE". I've heard same of" writeable "dvd.  And loss of
bus power can kill any write cache in a drive, of course."

Pat LaVarre



