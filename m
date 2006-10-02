From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Introduce BROKEN_ON_64BIT facility
Date: Mon, 02 Oct 2006 05:54:19 -0400
Message-ID: <4520E1CB.6070104@garzik.org>
References: <20061002045512.GA8835@havoc.gtf.org> <p737izjhwpa.fsf@verdi.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:49318 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750985AbWJBJya (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 05:54:30 -0400
In-Reply-To: <p737izjhwpa.fsf@verdi.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: chas@cmf.nrl.navy.mil, netdev@vger.kernel.org, kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de, mac@melware.de, markus.lidel@shadowconnect.com, samuel@sortiz.org, Neela.Kolli@engenio.com, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, thomas@winischhofer.net

Andi Kleen wrote:
> Jeff Garzik <jeff@garzik.org> writes:
> 
>> Add a broken-on-64bit option, similar to the existing broken-on-smp
>> config option.  This is just the first pass, marking the obvious
>> candidates.
> 
> When I had this problem in the past I just used && !64BIT.
> How is this new option different?

Same reason why we have CONFIG_BROKEN_ON_SMP separate from CONFIG_SMP.


> AFAIK I2O got fixed too. Do you have any evidence that it is really
> broken on 64bit?

i2o_config did not.  Just read the code, it's obvious...

	Jeff


