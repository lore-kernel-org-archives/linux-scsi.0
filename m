From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Sym53c8xx_2
Date: Sun, 15 Aug 2004 10:38:48 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0408151029290.2077@poirot.grange>
References: <1092366037.28144.202254467@webmail.messagingengine.com>  
 <Pine.LNX.4.60.0408132049060.4069@poirot.grange>
 <1092432298.18813.202307545@webmail.messagingengine.com>
 <Pine.LNX.4.60.0408150005570.5333@poirot.grange>
 <Pine.LNX.4.58.0408151008400.6676@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:17123 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S266544AbUHOIjb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Aug 2004 04:39:31 -0400
In-Reply-To: <Pine.LNX.4.58.0408151008400.6676@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Kai OM <epimetreus@fastmail.fm>, linux-scsi@vger.kernel.org

On Sun, 15 Aug 2004, Kai Makisara wrote:

> You missed one essential change in 2.6.6:

No, I didn't. I saw it, but just didn't realise that it's the introduction 
of the SPI, that triggered the Domain Validation. The transport template 
functions look quite harmless and are only triggered through sysfs. What 
if you disable SPI in 2.6.7 with the original dtiver? Does it work then?

Guennadi
---
Guennadi Liakhovetski

