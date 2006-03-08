From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 23/28] scsi cd: VariRec, GigaRec and PowerRec as user
Date: Wed, 08 Mar 2006 12:30:03 -0500
Message-ID: <440F149B.1040001@garzik.org>
References: <200603080816.k288GSQO002236@shell0.pdx.osdl.net> <1141830726.3194.8.camel@mulgrave.il.steeleye.com> <20060308154532.GJ7301@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:18328 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751127AbWCHRaX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 12:30:23 -0500
In-Reply-To: <20060308154532.GJ7301@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, akpm@osdl.org, linux-scsi@vger.kernel.org, T.Maguin@web.de, axboe@suse.de

Matthew Wilcox wrote:
> On Wed, Mar 08, 2006 at 09:12:06AM -0600, James Bottomley wrote:
> 
>>On Wed, 2006-03-08 at 00:14 -0800, akpm@osdl.org wrote:
>>
>>>From: Thomas Maguin <T.Maguin@web.de>
>>
>>>This patch allows normal users to eectute some Plextor drives
>>>commands:
>>>
>>>- Hide CD-R
>>>- SingleSession
>>>- SpeedRead
>>>- PowerRec
>>>- VariRec
>>>- GigaRec
>>>
>>
>>This one just isn't safe.  We can't add vendor specific commands to the
>>permissions table because they mean different things to different
>>vendors ... get mode on one could be halt and catch fire on another, so
>>the whole concept of safety via command verification is lost.
> 
> 
> Thanks for NAKing this one again, James.  I'm a bit disappointed akpm
> picked it up given that I explained how unsafe it was when it was posted:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113976322621230&w=2

I NAK'd it as well, for obvious reasons...

	Jeff



