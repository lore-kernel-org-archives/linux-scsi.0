From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Patch] Fix oops on rmmod usb-storage
Date: 29 Sep 2004 13:19:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096478376.2123.32.camel@mulgrave>
References: <415A67B8.2080003@suse.de>
	<20040929130332.A11785@infradead.org> <415AAB0F.2080802@suse.de>
	<20040929171251.GA5368@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:35204 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268637AbUI2RUo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 13:20:44 -0400
In-Reply-To: <20040929171251.GA5368@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Alan Stern <stern@rowland.harvard.edu>

On Wed, 2004-09-29 at 13:12, Mike Anderson wrote:
> We may want to reconsider a method to distinguish unexpected removals
> from clean removals.

Technically we have this: it's the recovery flag to scsi_host_cancel(). 
Unfortunately, scsi_remove_host doesn't have such a flag so it's always
set to zero at the moment.

James

