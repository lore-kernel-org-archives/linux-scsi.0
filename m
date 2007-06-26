From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Mon, 25 Jun 2007 18:04:44 -0700 (PDT)
Message-ID: <319583.29876.qm@web31809.mail.mud.yahoo.com>
References: <46804152.8050200@s5r6.in-berlin.de>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:40985 "HELO
	web31809.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751272AbXFZBEr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jun 2007 21:04:47 -0400
In-Reply-To: <46804152.8050200@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: Hannes Reinecke <hare@suse.de>, Swen Schillig <swen@vnet.ibm.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

--- Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Do all these transports use the same *name* for the attribute holding
> the target port identifier's?

Sure, it is "tpid".

> In other words, is userspace able to find
> the target port identifier without knowing which transport is at work?

How can that be?  The target port identifier is by definition
a transport property?

"Userspace" which you have in mind will be more interested in the
device name and other ID properties as returned by the INQUIRY
facilities.  Some are transport specific some are not.

Either way userspace can follow a pointer from the sysfs device
entry to the transport, just as sg-utils and lsscsi does now for
the SAS Stack (my version of it at least).

> Regarding the TPID:  The /how/ should be left to the transport layer
> implementation; but the /where/ should be uniform in all transports.

This maybe hard to do since the structure of the domain is different
for different protocols.

Of course this can be hacked by using symlinks...

   Luben

