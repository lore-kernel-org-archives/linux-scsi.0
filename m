From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Sym53c8xx_2
Date: Sun, 15 Aug 2004 10:45:27 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0408151044340.2742@poirot.grange>
References: <1092366037.28144.202254467@webmail.messagingengine.com>  
 <Pine.LNX.4.60.0408132049060.4069@poirot.grange>
 <1092432298.18813.202307545@webmail.messagingengine.com>
 <Pine.LNX.4.60.0408150005570.5333@poirot.grange>
 <Pine.LNX.4.58.0408151008400.6676@kai.makisara.local>
 <Pine.LNX.4.60.0408151029290.2077@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:39361 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S266549AbUHOIqb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Aug 2004 04:46:31 -0400
In-Reply-To: <Pine.LNX.4.60.0408151029290.2077@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Kai OM <epimetreus@fastmail.fm>, linux-scsi@vger.kernel.org

On Sun, 15 Aug 2004, Guennadi Liakhovetski wrote:

> functions look quite harmless and are only triggered through sysfs. What if 
> you disable SPI in 2.6.7 with the original dtiver? Does it work then?

Ough, I see:

config SCSI_SYM53C8XX_2
         tristate "SYM53C8XX Version 2 SCSI support"
         depends on PCI && SCSI
         select SCSI_SPI_ATTRS

...and it works on my 2-way too... Ok, I'll re-think it:-)

Guennadi
---
Guennadi Liakhovetski

