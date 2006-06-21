From: Christian Iversen <chrivers@iversen-net.dk>
Subject: Re: Controller failing, driver not behaving nicely
Date: Wed, 21 Jun 2006 03:08:57 +0200
Message-ID: <200606210308.57669.chrivers@iversen-net.dk>
References: <200606202302.19858.chrivers@iversen-net.dk> <b1bc6a000606201547r11916e86g814d006c99ce386e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from port741.ds1-noe.adsl.cybercity.dk ([212.242.204.118]:36150 "EHLO
	boreas.iversen-net.dk") by vger.kernel.org with ESMTP
	id S932346AbWFUBIu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jun 2006 21:08:50 -0400
Received: from zephyr.iversen-net.dk (zephyr.iversen-net.dk [10.0.0.2])
	by boreas.iversen-net.dk (Postfix) with ESMTP id 676202B9ECB
	for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2006 03:08:51 +0200 (CEST)
In-Reply-To: <b1bc6a000606201547r11916e86g814d006c99ce386e@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wednesday 21 June 2006 00:47, adam radford wrote:
> Christian,
>
> 0x28 is the scsi opcode for READ_10, which means the command that
> failed was a read command.

Makes sense - that just happened to be what the kernel requested at the time. 

> The driver is trying to reset the card, however it is failing the reset.
>
> "AEN drain failed, retrying." means your card is not responding.

I assume it's trying to flush all pending commands or somesuch? What is AEN?

> I would suggest reseating your card if you have moved it recently, 

I have - but only because I had this problem before, and I tried to solve it 
that way. So that's not going to work, I'm afraid. 

> or the card could be dying in which case you should contact 3ware/AMCC
> support. 

Yeah I feared that. Too bad, it was a good card :-(

(It's bought off of eBay, so I don't think there's any hope for a 
replacement).

Thank you very much for the help!


Wait - how is it that a driver can't reset the card, but a hw reset always 
can? Is there some more fundamental type of reset possible, than what the 
driver currently tries? Or would that require resetting everything?

It would be ultra-neat if the driver could just stall for a few seconds (or 
even a minute). That'd be so much more bearable, compared to a terabyte-class 
raid5 just suddenly failing. 

Or at least, maybe the driver could try to reset the card a few more times? 
Sometimes it seems to work after a couple of attempts. 

-- 
Regards,
Christian Iversen
