From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sun, 29 Feb 2004 14:44:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4042410C.7070701@pobox.com>
References: <1077906383.2157.98.camel@mulgrave> <3462370000.1077909838@aslan.btc.adaptec.com> <403FFF86.90302@pobox.com> <20040228092512.GD923@suse.de> <4041292C.3090700@pobox.com> <20040229091350.GC3149@suse.de> <137982704.1078081053@aslan.btc.adaptec.com> <404236C1.5000001@pobox.com> <156412704.1078082931@aslan.btc.adaptec.com> <40423F7B.4020102@pobox.com> <162922704.1078083749@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:23760 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262123AbUB2ToY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 14:44:24 -0500
In-Reply-To: <162922704.1078083749@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

Justin T. Gibbs wrote:
>>>Exactly.  The block layer shouldn't be involved in this at all.  In the
>>>particular case I was talking about, busy or queue full with no I/O pending,
> 
>                                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> 
>>Agreed for busy.
>>
>>But queue full?
> 
> 
> Some SCSI devices send Queue Full instead of Busy in the case of
> a "busy" condition with no I/O pending.


Gotcha, thanks.

	Jeff



