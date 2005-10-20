From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Thu, 20 Oct 2005 19:22:39 +0200
Message-ID: <1129828959.2807.18.camel@laptopd505.fenrus.org>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>
	 <20051020160155.GA14296@lst.de> <4357CB03.4020400@adaptec.com>
	 <20051020170330.GA16458@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:22711 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932496AbVJTRWu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 13:22:50 -0400
In-Reply-To: <20051020170330.GA16458@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, jejb@steeleye.com, "Moore, Eric Dean" <Eric.Moore@lsil.com>, Luben Tuikov <luben_tuikov@adaptec.com>


> We are not going to implement SDI in the kernel.  Long before SDI or
> it's predecessor, HP CSMI were designed we made it clear we're not going
> to accept wide ioctl-APIs, especially when they're even bad for old
> ioctl API standards.  The CSMI spec has been passed around in an early
> phase and been totally rejected, 

Just to say AYE on this:

the problem with these things is that they define an IOCTL interface,
while a library level interface would have been a LOT better. By far.
That way the spec doesn't define the implementation, but only a real
INTERFACE while allowing flexibility and compatibility. IOCTLs are just
very very much the wrong layer to put such an interface. (just as
posix/sus specify the (g)libc interface and not the kernel interface,
although of course they impact it somewhat and glibc can for several
things do a straight pass-through to the raw kernel interface).


