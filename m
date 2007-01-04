From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] SCSI, libata: add support for ATA_16  commands to libata
 ATAPI devices
Date: Thu, 04 Jan 2007 10:29:13 -0500
Message-ID: <459D1D49.3060909@rtr.ca>
References: <200701021935.07840.liml@rtr.ca> <1167788405.3687.25.camel@mulgrave.il.steeleye.com> <459B4243.5080804@rtr.ca> <1167838307.2789.12.camel@mulgrave.il.steeleye.com> <459C066D.30507@torque.net> <1167860496.2789.70.camel@mulgrave.il.steeleye.com> <20070104150900.GD11203@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([64.26.128.89]:4210 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964907AbXADP3U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jan 2007 10:29:20 -0500
In-Reply-To: <20070104150900.GD11203@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, dougg@torque.net, Linux IDE <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Wed, Jan 03 2007, James Bottomley wrote:
>> Er, well, as you know, I've never been a fan of this static list.  I
>> thought Jens was going to put us all out of our misery by making the
>> list settable per device by root and thus shovel the problem off onto
>> the distros?
> 
> The code is there, just haven't had the guts to merge it yet.
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=bf5f922d167a5c5cf57132bbcaa1e0ddfd5c45f7
> 

That's nice, but doesn't help with the case of trying to do ATA passthru
to ATAPI devices, the subject of the original patch here.

Cheers!
