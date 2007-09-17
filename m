From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patchset 0/24] Lots of the Accessors patches and !use_sg cleanup
Date: Mon, 17 Sep 2007 13:36:30 +0200
Message-ID: <46EE66BE.4050003@panasas.com>
References: <46E6F92D.2090409@panasas.com> <200709171246.15142.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:7379 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753500AbXIQLgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Sep 2007 07:36:35 -0400
In-Reply-To: <200709171246.15142.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Sep 17 2007 at 12:46 +0200, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> On Tuesday 11 September 2007, Boaz Harrosh wrote:
>> Here are more accessors patches. I have tried
>> to find Maintainers of drivers but please help me if
>> I missed any.
> 
> [ ... ]
> 
>> 0010 	drivers/scsi/eata_pio.c - Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> ?
> 
> not me, according to MAINTAINTERS file:
> 
> EATA-PIO SCSI DRIVER
> P:      Michael Neuffer
> M:      mike@i-Connect.Net
> L:      linux-eata@i-connect.net, linux-scsi@vger.kernel.org
> S:      Maintained
> 
> BTW patch looks obviously OK
> 
>> 0024 	drivers/scsi/ide-scsi.c - Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> This reminds me that ide-scsi needs a real Maintainer, I don't have a time to
> closely follow-up SCSI changes...
> 
> Thanks,
> Bart

Thanks! I sent him and the list a Note. I hope to get their ACK.

I did a case insensitive search on MAINTAINTERS for most drivers
but here I tripped over the "-" vs "_" thing.

Is there a script that helps match file name to maintainer?

Thanks again
Boaz

