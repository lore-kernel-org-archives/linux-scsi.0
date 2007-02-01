From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] RESEND: SCSI, libata: add support for ATA_16 commands
	to libata ATAPI devices
Date: Thu, 01 Feb 2007 09:09:25 -0600
Message-ID: <1170342565.3388.4.camel@mulgrave.il.steeleye.com>
References: <200701021935.07840.liml@rtr.ca>
	 <200701311346.26644.liml@rtr.ca> <45C1356B.6000907@gmail.com>
	 <45C1377F.6070001@rtr.ca> <45C138E8.1040706@gmail.com>
	 <45C1A4BD.3030909@garzik.org> <45C1A823.30008@gmail.com>
	 <45C1B8D4.1070209@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:42381 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422914AbXBAPJd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Feb 2007 10:09:33 -0500
In-Reply-To: <45C1B8D4.1070209@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, Mark Lord <liml@rtr.ca>, Linux IDE <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org

On Thu, 2007-02-01 at 04:54 -0500, Jeff Garzik wrote:
> Agreed... but that doesn't make it the /right/ thing to do ;-)
> 
> The logic behind the current code, which limits to the maximum size 
> allowed by an attached device on the port, is mainly to leverage the 
> SCSI layer as a filter for bad CDB lengths.
> 
> IOW, it's called "being lazy" ;-)

But you're requesting code changes in the SCSI layer because of this
incorrect usage.  max_cdb is supposed to be the *host* limit.  The mid
layer finds out and respects device limits separately from this.

James


