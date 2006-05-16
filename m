From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 12:39:13 -0400
Message-ID: <446A0031.1080209@garzik.org>
References: <4468B596.9090508@garzik.org>	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>	 <4469F2B2.703@garzik.org>	 <1147794708.3505.30.camel@mulgrave.il.steeleye.com>	 <4469F879.9020009@garzik.org> <1147797042.3505.44.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:4485 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932125AbWEPQjP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 12:39:15 -0400
In-Reply-To: <1147797042.3505.44.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

James Bottomley wrote:
> On Tue, 2006-05-16 at 12:06 -0400, Jeff Garzik wrote:
>> Sigh.  They clearly do not have the same effect, because the above code 
>> guarantees that a timeout is forced, regardless of whether the timer has 
>> fired or not.  That in turn guarantees that the timeout callback 
>> (->eh_timed_out) is called, and the cmd is in a very specific state.
> 
> the API claims to be forcibly aborting a command, which is *not* a
> timeout  ... trying to pretend to the midlayer that it is is the wrong
> processing model.  You may choose to call this API because of a class
> internal timeout, but you don't need the callback notification that it
> is a timeout in this case, you already know it is.

I can certainly agree the name may not be the best choice.  Naming based 
on implementation, it could be scsi_force_timeout_cmd() or somesuch.

	Jeff


