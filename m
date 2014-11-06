From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: Large disk drives
Date: Thu, 06 Nov 2014 18:34:28 +0200
Message-ID: <545BA314.4050109@plexistor.com>
References: <1415203668.13212.2.camel@jarvis>		 <Pine.LNX.4.44L0.1411051130470.1531-100000@iolanthe.rowland.org>		 <20141105193045.GA13265@infradead.org>	 <1415269814.29907.19.camel@jarvis.quadriga.com>	 <545B86AC.3080704@plexistor.com> <1415289258.10617.4.camel@jarvis.quadriga.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:39263 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaKFQeb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2014 11:34:31 -0500
Received: by mail-wg0-f52.google.com with SMTP id b13so1625540wgh.11
        for <linux-scsi@vger.kernel.org>; Thu, 06 Nov 2014 08:34:30 -0800 (PST)
In-Reply-To: <1415289258.10617.4.camel@jarvis.quadriga.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, "Dale R. Worley" <worley@alum.mit.edu>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On 11/06/2014 05:54 PM, James Bottomley wrote:
> 
> We don't have a failure.  This is the problem.  Determining that a
> problem exists 
> 

OK Sorry. I assumed the bridge is smart enough to do nothing,

ie READ_CAPACITY_10 is passed as is via sata to the device that
actually supports READ_CAPACITY_16, as I understand then the 
actual good drive is not suppose to send size-modulue-2G in
response to READ_CAPACITY_10. Should it ?

Then the bridge just sends that back to me, now if I send
READ_CAPACITY_16 the bridge will return NOT-SUPPORTED because
it is unexpected.

But what are you saying that the bridge was smart enough to
do READ_CAPACITY_16 get a 64bit value from the drive and then
return the lower 32bit to me ? Really ? I would not imagine
in the life of me someone so dumb. And surly it is against
any spec.

Are you sure ? I think you are wrong I think the guy reported
that he can only see 2T out of his 3T drive which means the
bridge returned 0xffffffff, exactly 2T

> James
> 
> 

But hey, I guess stupidity is limitless, this one here pushing
real far.

Cheers
Boaz

