From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: Time to conclude the Sony USB mass storage
	thread
Date: 14 Nov 2003 10:52:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068832361.5539.73.camel@patrh9>
References: <1068825146.2134.6.camel@mulgrave>
	 <20031114092644.A2794@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:53729 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264643AbTKNRxR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 12:53:17 -0500
In-Reply-To: <20031114092644.A2794@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org, james.bottomley@steeleye.com, mdharm-scsi@one-eyed-alien.net

> allows the setting to be overwritten for specific vendor + model
> via the scsi_devinfo/dev_flags code - so users or distributions can white
> list devices without modifying the kernel (devinfo settings have priority
> over shost->flags, see scsi_devinfo.c).

Yes please.

> for clarity: ...
> BLIST_MS_SKIP_PAGE_08 means for sd assume write through cache ...
> BLIST_MS_SKIP_PAGE_3F means for sd assume writable media.

Ah.

Pat LaVarre


