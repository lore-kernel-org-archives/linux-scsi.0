From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: Patches for SCSI scanning
Date: Thu, 22 Apr 2004 06:17:39 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFCF6A39DF.678B58DE-ONC1256E7D.00837C2C@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:33444 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S263200AbUDVERy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 00:17:54 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Kurt Garloff <garloff@suse.de>, Andrew Morton <akpm@osdl.org>, Linux SCSI list <linux-scsi@vger.kernel.org>





> On Tue, 2004-04-20 at 11:03, Kurt Garloff wrote:
> > Linux maps 8 byte LUNs to a 32bit number in scsilun_to_int().
> > There are several ways to use the 8 bytes, but the mapping assumes
> > a particular model which is often used and the mapping is nice in
> > that it results in LUNs being 0, 1, 2, ...
> > However, there are other possibilities. And as soon as the last
> > four bytes are non-zero, the mapping will break down :-/
> > The S/390 folks seem to have such devices.
>
> This looks like it needs fixing in our lun mapping support, doesn't it,
> rather than trying to work around it with a flag?

Yes. I first thought too few people would interested in it for 2.6.
But this sounds encouraging. Let's fix it.

Cheers,
Martin

