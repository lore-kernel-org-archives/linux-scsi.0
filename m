From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Notify about errors during initialization
Date: Tue, 6 Jan 2004 16:17:31 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040106161731.A17858@infradead.org>
References: <20040105021047.GD30408@one-eyed-alien.net> <Pine.LNX.4.44L0.0401051659180.604-100000@ida.rowland.org> <20040105221302.A7678@infradead.org> <20040105233221.GC1936@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:21262 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262050AbUAFQRo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2004 11:17:44 -0500
Content-Disposition: inline
In-Reply-To: <20040105233221.GC1936@beaverton.ibm.com>; from andmike@us.ibm.com on Mon, Jan 05, 2004 at 03:32:21PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Jan 05, 2004 at 03:32:21PM -0800, Mike Anderson wrote:
> It would appear that saying the scan requested by scsi_scan_host is
> completed when the function returns would be the expected result. The
> LLDD writer should be aware that once scsi_add_host has been called
> hotplug events to user space could allow the user space to scan and
> delete devices through sysfs making assumptions on devices found or not
> found iffy.

> ...

> I thought we where moving to not calling a scan api from the LLDD and
> using hotplug events. Then user space would define the scan policy it
> wanted.

My idea was that in the brave new hotplug world scsi_scan_host would
do nothing but simply sending a SCAN hotplug even.  With that design
we'd have a hard time to find out when the scanning has finished in
kernelspace.
