From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: iSCSI vs. NBD (was Re: ata over ethernet question)
Date: Fri, 13 May 2005 20:50:18 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0505132040400.8052@poirot.grange>
References: <1416215015.20050504193114@dns.toxicfilms.tv>
 <1115236116.7761.19.camel@dhollis-lnx.sunera.com>  <1104082357.20050504231722@dns.toxicfilms.tv>
  <1115305794.3071.5.camel@dhollis-lnx.sunera.com>  <20050507150538.GA800@favonius>
  <Pine.LNX.4.60.0505102352430.9008@poirot.grange> <1115923927.5042.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:44263 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262474AbVEMUJz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2005 16:09:55 -0400
In-Reply-To: <1115923927.5042.18.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Sander <sander@humilis.net>, David Hollis <dhollis@davehollis.com>, Maciej Soltysiak <solt2@dns.toxicfilms.tv>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 12 May 2005, James Bottomley wrote:

> However, there is room for improvement in nbd, notably the handling of
> packet commands, which looks to be eminently doable in the current
> infrastructure (this would basically make nbd a replicator for the linux
> block system, and would probably necessitate some client side changes to
> achieve).  If you have any thoughts in this direction, you could drop an
> email to the maintainer.

Thanks, James

I'll try to get some (thoughts):-) BTW, who is the maintainer of nbd? No 
one in MAINTAINERS, in nbd.c only
 * Copyright 1997-2000 Pavel Machek <pavel@ucw.cz>
 * Parts copyright 2001 Steven Whitehouse <steve@chygwyn.com>
Is it Pavel then?

Thanks
Guennadi
---
Guennadi Liakhovetski

