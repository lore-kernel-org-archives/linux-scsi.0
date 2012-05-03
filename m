From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: pull request: linux-firmware: Update qla2xxx firmware files.
Date: Wed, 2 May 2012 21:16:01 -0700
Message-ID: <20120503041600.GJ1440@plapa.qlogic.org>
References: <alpine.WNT.2.00.1204271521300.1704@N5102REMCQXM4BS.qlogic.org>
 <1335836916.8274.50.camel@deadeye>
 <20120501020525.GE67085@plapa.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:29213 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754312Ab2ECPkz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 May 2012 11:40:55 -0400
Content-Disposition: inline
In-Reply-To: <20120501020525.GE67085@plapa.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, "dwmw2@infradead.org" <dwmw2@infradead.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 30 Apr 2012, Andrew Vasquez wrote:

> On Mon, 30 Apr 2012, Ben Hutchings wrote:
> 
> > On Fri, 2012-04-27 at 15:41 -0400, Chad Dupuis wrote:
> > > Hi Ben, David,
> > > 
> > > Can you please pull the following patches from the "for_upstream" branch
> > > of the repo below to update the ql2300_fw.bin, ql2322_fw.bin,
> > > ql2400_fw.bin and ql2500_fw.bin files?
> > > 
> > > git://avgit01.qlogic.org/linux-firmware for_upstream
> > 
> > That hostname isn't resolvable here and now.
> 
> Ben,
> 
> Actually, the forward-facing URL is actually:
> 
> 	git://git.qlogic.com/linux-firmware
> 
> But...there seems to be a problem, as there's no A record for that
> server.
> 
> We will let you know when we get that issue resolved.


Ben,

Thanks for your patience here, you should now be able to pull from the
URL above:

	$ git clone git://git.qlogic.com/linux-firmware 
	Cloning into 'linux-firmware'...
	remote: Counting objects: 1628, done.
	remote: Compressing objects: 100% (768/768), done.
	remote: Total 1628 (delta 833), reused 1628 (delta 833)
	Receiving objects: 100% (1628/1628), 29.86 MiB | 1.16 MiB/s, done.
	Resolving deltas: 100% (833/833), done.

-- av

> > > Chad Dupuis (4):
> > >    qla2xxx: Update ql2300_fw.bin to version 3.03.28.
> > >    qla2xxx: Update ql2322_fw.bin to version 3.03.28.
> > >    qla2xxx: Update ql2400_fw.bin to version 5.06.05.
> > >    qla2xxx: Update ql2500_fw.bin to version 5.06.05.
> > > 
> > >   WHENCE        |    8 ++++----
> > >   ql2300_fw.bin |  Bin 123170 -> 125252 bytes
> > >   ql2322_fw.bin |  Bin 132978 -> 136038 bytes
> > >   ql2400_fw.bin |  Bin 228056 -> 255320 bytes
> > >   ql2500_fw.bin |  Bin 199776 -> 252636 bytes
> > >   5 files changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > Thanks,
> > > Chad
> > > 
> > > This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
> > > 
> > > 
> > 
> > -- 
> > Ben Hutchings
> > Design a system any fool can use, and only a fool will want to use it.
> 
> 

