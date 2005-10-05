From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] 3ware: use scsi_scan_target()
Date: Wed, 05 Oct 2005 15:24:30 -0400
Message-ID: <4344286E.5090306@pobox.com>
References: <4341D38A.40509@pobox.com> <20051005162850.GA17710@infradead.org> <43442312.4030304@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:3547 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932634AbVJETYh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2005 15:24:37 -0400
In-Reply-To: <43442312.4030304@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linuxraid@amcc.com

Luben Tuikov wrote:
> On 10/05/05 12:28, Christoph Hellwig wrote:
>>How does 3x-9xxx support luns?  From reading the

> AFAIR the firmware just exports the LUs.  The FW doesn't
> support REPORT LUNS; the LLDD exported LUs directly to SCSI Core.

Some 9xxx firmwares do support LUNs:

>         /* Check if this FW supports luns */
>         if ((SCpnt->device->lun != 0) && (tw_dev->working_srl < TW_FW_SRL_LUNS_SUPPORTED)) {

and the newer 9xxx are quite different from 3w-xxxx, because 9xxx 
firmware interface is largely just a execute-scsi-command message, 
rather than the translation stuff the goes on in 3w-xxxx.

As to Christoph's question, _how_ does the firmware support LUNs?  No 
idea.  It clearly does support it, though.

	Jeff


