From: Ramya Desai <ramya.desai@gmail.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Fri, 19 Feb 2010 18:13:36 +0530
Message-ID: <3e7aae31002190443w44418778u6180c74d51a0f783@mail.gmail.com>
References: <3e7aae31002170437i52ba4ba1w10c1ff224d9b37ef@mail.gmail.com>
	 <1266418952.2787.5.camel@mulgrave.site>
	 <3e7aae31002180046i771f2e1encfcda864f564c87e@mail.gmail.com>
	 <1266508049.4355.37.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:21801 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab0BSMnh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2010 07:43:37 -0500
In-Reply-To: <1266508049.4355.37.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>

> In that case, it looks like the helpers in protocol.c do use chaining
> correctly (as long as the driver isn't doing direct dma), but there's a
> clamp on the sg table size in scsiglue.c:
>
> .sg_tablesize = SG_ALL
>
> That would have to be changed to SCSI_MAX_SG_CHAIN_SEGMENTS to enable
> chaining.

Even after changing .sg_tablesize  to SCSI_MAX_SG_CHAIN_SEGMENTS, I am
getting the same results (maximum 512KB of data transfer buffers in
scsi_command).
Is there any thing, that I am missing. Do I need to send any logs to
analyze the problem?

Regards,
RD
