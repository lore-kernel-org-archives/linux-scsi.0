From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Need help with libata error handling in libsas
Date: Mon, 25 Feb 2008 08:57:10 -0800
Message-ID: <1203958631.3254.48.camel@localhost.localdomain>
References: <1203886936.3135.75.camel@localhost.localdomain>
	 <47C2EE15.3060105@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59895 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756610AbYBYQ5Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 11:57:16 -0500
In-Reply-To: <47C2EE15.3060105@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2008-02-25 at 10:34 -0600, Brian King wrote:
> The new libata-eh is used for more than just EH. It is used for device
> probing, device revalidation, and power management. It is also woken for
> all command failures and is where the request sense for ATAPI devices is
> issued. Device revalidation following reset is also critical for ATA and
> ATAPI devices. One example of this is some SATA/PATA converter chips
> lose their DMA xfer settings following a reset and default to PIO mode
> only. Any DMA transfer that is attempted simply hangs.

OK ... I'm grepping around in the source trying to figure out all of
this.  Is it documented anywhere?  That would really help me out at the
moment.

James


