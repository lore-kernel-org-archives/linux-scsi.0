From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Fri, 15 Jun 2007 17:50:50 -0400
Message-ID: <467309BA.8000009@garzik.org>
References: <20070615120848.352093000@pademelon.sonytel.be>	<1181918159.25228.543.camel@pmac.infradead.org>	<Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be> <20070615.141720.112626963.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60027 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759241AbXFOVu5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2007 17:50:57 -0400
In-Reply-To: <20070615.141720.112626963.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org, axboe@kernel.dk, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org

David Miller wrote:
> It's senseless to make people build new major/minor numbers for
> all these new quirky storage drivers.  People have to add support
> for the new major number to installers and all kinds of other
> tools.


FWIW that's why libata followed the path it did:  faking SCSI required 
the least amount of code for the maximal amount of existing storage 
driver and platform installer support.

Well, that and the fact that ATAPI is really SCSI, but that's offtopic 
for this thread.  :)

	Jeff


