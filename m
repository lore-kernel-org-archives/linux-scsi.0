From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Fri, 30 Sep 2005 18:01:59 -0400
Message-ID: <433DB5D7.3020806@adaptec.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01A9FA11@otce2k03.adaptec.com>	 <1128105594.10079.109.camel@bluto.andrew>  <433D9035.6000504@adaptec.com>	 <1128111290.10079.147.camel@bluto.andrew>  <433DA0DF.9080308@adaptec.com> <1128114950.10079.170.camel@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:42969 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932293AbVI3WCB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Sep 2005 18:02:01 -0400
In-Reply-To: <1128114950.10079.170.camel@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.patterson@hp.com
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, dougg@torque.net, Linus Torvalds <torvalds@osdl.org>, Luben Tuikov <ltuikov@yahoo.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On 09/30/05 17:15, Andrew Patterson wrote:
>>Sorry but I completely fail to see this argument., locks it, then hangs.
>>
>>How will it "fail for most storage managament apps"?
> 
> 
> Let's see, one example:
> 
> Process A opens an attribute and writes to it.  Process B opens another
> attribute and writes to it, affecting the result that process A will see
> from its subsequent read. I suppose you could lock every attribute, but
> that would be very error-prone, and not allow much concurrency.

Why should synchronization between Process A and Process B 
reading storage attributes take place in the kernel?

They can synchronize in user space.

	Luben
