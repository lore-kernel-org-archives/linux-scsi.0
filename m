From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Mon, 03 Oct 2005 12:23:24 -0400
Message-ID: <43415AFC.5080501@adaptec.com>
References: <Pine.LNX.4.10.10509300015100.27623-100000@master.linux-ide.org> <433D8542.1010601@adaptec.com> <433DD0F8.4000501@pobox.com> <43413CE8.1090306@adaptec.com> <434154F0.9070105@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:47852 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751105AbVJCQX1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2005 12:23:27 -0400
In-Reply-To: <434154F0.9070105@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andre Hedrick <andre@linux-ide.org>, "David S. Miller" <davem@davemloft.net>, willy@w.ods.org, patmans@us.ibm.com, ltuikov@yahoo.com, linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On 10/03/05 11:57, Jeff Garzik wrote:
>>From what I see, because of its *layering* position
>>JB's "transport attributes" cannot satisfy open transport.
> 
> 
> Repeating verbatim the above quote:  a transport class is more than just 
> transport attributes.

a) "Transport Attributes" _is_ its name,
b) It sits across SCSI Core, i.e. on the same level.
c) It was never intended to add management.
d) Its inteface to SCSI Core is badly defined and an "invention",
   (and very poor at that).

The reason for d) is that
1) it tries to unify different _transports_,
2) does _not_ follow _any_ spec or standard.

Look at this, while you repeat verbaitm a single
quote, I give you technical arguments, then you just
repeat a single quote verbatim... Sad.

> Every chip is ultimately an interface to the transport, regardless of 
> whether the transport layer is largely managed by software (aic94xx) or 
> firmware (MPT).  SCSI host template can work just fine with open 
> transport hardware.

Maybe the picures and the write up here will help:
http://marc.theaimsgroup.com/?l=linux-kernel&m=112810649712793&w=2

	Luben


