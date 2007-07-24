From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
Date: Tue, 24 Jul 2007 09:44:21 -0400
Message-ID: <46A60235.10107@garzik.org>
References: <20070716161539.075822000@pademelon.sonytel.be>	<20070716162206.392129000@pademelon.sonytel.be>	<20070718163637.3f0e0164.akpm@linux-foundation.org>	<46A5E610.7000508@shadowen.org> <46A5F275.7060905@garzik.org> <je3aze6k1b.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55996 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbXGXNo3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2007 09:44:29 -0400
In-Reply-To: <je3aze6k1b.fsf@sykes.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Schwab <schwab@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Andrew Morton <akpm@linux-foundation.org>

Andreas Schwab wrote:
> Jeff Garzik <jeff@garzik.org> writes:
> 
>> Andy Whitcroft wrote:
>>> Andrew Morton wrote:
>>>
>>>>> +	start_sector = req->sector*priv->blocking_factor;
>>>>> +	sectors = req->nr_sectors*priv->blocking_factor;
>>>> s/*/ * /.  checkpatch missed this.
>>> Ok, this is something we need to decide on.  Currently we only ask for
>>> consistent spacing on all the mathematic operators.  This is mostly as
>>> we do see a large number of non-spaced uses in defines and the like.
>>>
>>> I am happy to expand these tests so they are always spaced on both sides
>>> style if that is the preference.
>> That is most definitely the preference:  spaces surround operators.
>                                                           ^binary

Yes.  :)

	Jeff



