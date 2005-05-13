From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: iSCSI vs. NBD (was Re: ata over ethernet question)
Date: Fri, 13 May 2005 16:21:33 -0400
Message-ID: <1116015693.6639.4.camel@mulgrave>
References: <1416215015.20050504193114@dns.toxicfilms.tv>
	 <1115236116.7761.19.camel@dhollis-lnx.sunera.com>
	 <1104082357.20050504231722@dns.toxicfilms.tv>
	 <1115305794.3071.5.camel@dhollis-lnx.sunera.com>
	 <20050507150538.GA800@favonius>
	 <Pine.LNX.4.60.0505102352430.9008@poirot.grange>
	 <1115923927.5042.18.camel@mulgrave>
	 <Pine.LNX.4.60.0505132040400.8052@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:34540 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262533AbVEMUVu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2005 16:21:50 -0400
In-Reply-To: <Pine.LNX.4.60.0505132040400.8052@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sander <sander@humilis.net>, David Hollis <dhollis@davehollis.com>, Maciej Soltysiak <solt2@dns.toxicfilms.tv>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-05-13 at 20:50 +0200, Guennadi Liakhovetski wrote:
> I'll try to get some (thoughts):-) BTW, who is the maintainer of nbd? No 
> one in MAINTAINERS, in nbd.c only
>  * Copyright 1997-2000 Pavel Machek <pavel@ucw.cz>
>  * Parts copyright 2001 Steven Whitehouse <steve@chygwyn.com>
> Is it Pavel then?

Well, my copy of the MAINTAINERS file has this:

NETWORK BLOCK DEVICE
P:      Paul Clements
M:      Paul.Clements@steeleye.com
S:      Maintained

James

