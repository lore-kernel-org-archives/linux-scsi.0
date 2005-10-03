From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Mon, 03 Oct 2005 11:57:36 -0400
Message-ID: <434154F0.9070105@pobox.com>
References: <Pine.LNX.4.10.10509300015100.27623-100000@master.linux-ide.org> <433D8542.1010601@adaptec.com> <433DD0F8.4000501@pobox.com> <43413CE8.1090306@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:25244 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932329AbVJCP5p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2005 11:57:45 -0400
In-Reply-To: <43413CE8.1090306@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Andre Hedrick <andre@linux-ide.org>, "David S. Miller" <davem@davemloft.net>, willy@w.ods.org, patmans@us.ibm.com, ltuikov@yahoo.com, linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Luben Tuikov wrote:
> On 09/30/05 19:57, Jeff Garzik wrote:
>>Luben Tuikov wrote:
>>>MPT-based drivers + James Bottomley's "transport attributes"

>>You continue to fail to see that a transport class is more than just 
>>transport attributes.
>>
>>You continue to fail to see that working on transport class support IS a 
>>transport layer, that includes management.
>>
>>Is you don't understand this fundamental stuff, how can we expect you to 
>>get it right?
> 
> 
>>From what I see, because of its *layering* position
> JB's "transport attributes" cannot satisfy open transport.

Repeating verbatim the above quote:  a transport class is more than just 
transport attributes.


> The reason is that MPT-based drivers indeed do need host template
> in the LLDD.

> Open Transport (SBP/USB/SAS) do not, since the chip is only
> an interface to the transport.

> The host template is implemented by a transport layer,
> say USB Storage or the SAS Transport Layer.

Every chip is ultimately an interface to the transport, regardless of 
whether the transport layer is largely managed by software (aic94xx) or 
firmware (MPT).  SCSI host template can work just fine with open 
transport hardware.

	Jeff


