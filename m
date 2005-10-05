From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] 3ware: use scsi_scan_target()
Date: Wed, 05 Oct 2005 15:01:38 -0400
Message-ID: <43442312.4030304@adaptec.com>
References: <4341D38A.40509@pobox.com> <20051005162850.GA17710@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:13506 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1030277AbVJETBl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2005 15:01:41 -0400
In-Reply-To: <20051005162850.GA17710@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linuxraid@amcc.com

On 10/05/05 12:28, Christoph Hellwig wrote:
> On Mon, Oct 03, 2005 at 08:57:46PM -0400, Jeff Garzik wrote:
> 
>>This change updates the 3ware raid drivers to use scsi_scan_target(), 
>>rather than scsi_scan_host().  This is especially nice for 3w-xxxx, 
>>which does not support LUNs.  The device scan is a bit quicker and more 
>>direct, even if it is a tiny bit more code in the driver.
> 
> 
> if it doesn't support luns scsi_add_device sounds like the better
> interface to use.

I agree.

> How does 3x-9xxx support luns?  From reading the

AFAIR the firmware just exports the LUs.  The FW doesn't
support REPORT LUNS; the LLDD exported LUs directly to SCSI Core.

	Luben
