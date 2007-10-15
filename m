From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git patches] libata update
Date: Mon, 15 Oct 2007 18:31:53 -0400
Message-ID: <4713EA59.30409@garzik.org>
References: <20071012194002.GA1545@havoc.gtf.org> <200710130342.22217.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:59274 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbXJOWb5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Oct 2007 18:31:57 -0400
In-Reply-To: <200710130342.22217.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>, Kristoffer Nyborg Gregertsen <kngregertsen@norway.atmel.com>

Bartlomiej Zolnierkiewicz wrote:
> On Friday 12 October 2007, Jeff Garzik wrote:
>> [ I just sent this upstream to Andrew and Linus ]
>>
>> Now that I have nailed down the corruption problem, I can attend to
>> this...  Fun stuff:
>>
>> * port multiplier support (like an ethernet hub, only dumber)
> 
> Great to see this here.
> 
>> * Asynchronous notification -- finally userspace CD-ROM polling can go away!
> 
> Is this AHCI specific or could be used by some other SATA hosts?

Can be used by any controller that supports SNotification (or is able to 
capture and parse the raw FIS's).

And FWIW, Tejun's PMP work also uses a few bits of same async-notify stuff.

I agree with your review items, and will look at those if others don't 
beat me to it.

	Jeff



