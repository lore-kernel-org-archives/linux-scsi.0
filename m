From: Jeff Garzik <jeff@garzik.org>
Subject: Re: generating a Linux WWN?
Date: Fri, 05 Oct 2007 18:52:16 -0400
Message-ID: <4706C020.3070400@garzik.org>
References: <1191622488.3475.54.camel@localhost.localdomain>	<20071005.151711.112302061.davem@davemloft.net>	<4706BDA4.7090106@garzik.org> <20071005.154901.88487279.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:49768 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762304AbXJEWwW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Oct 2007 18:52:22 -0400
In-Reply-To: <20071005.154901.88487279.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: James.Bottomley@SteelEye.com, ltuikov@yahoo.com, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Fri, 05 Oct 2007 18:41:40 -0400
> 
>> And that's been my plan from day one...  which is remarkably a lot like 
>> the behavior of several net drivers.  :)
>>
>> * attempt to read WWN during module load
>> * admin may optionally choose to manually specify OR auto-generate a WWN
>> * fail, if no WWN [stating the obvious]
> 
> And like with networking cases, we have situations where a platform
> might be able to assist.
> 
> There are several systems that provide a "system MAC address"
> to use when you can't obtain one for a specific device.  This
> valus is provided via a firmware property.
> 
> Similarly, we could ask an interface that goes to platform to
> ask them for a WWN.

Good point -- I bet I will run into this when I get a Broadcom HT-1100 
test system, which is the on-board version of the board supported by my 
new 'broadsas' driver.

	Jeff



