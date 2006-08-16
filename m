From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qlogic 2312 problems on 2.6.16.22, 2.6.18rc4
Date: Wed, 16 Aug 2006 11:14:45 -0700
Message-ID: <20060816181445.GU3674@andrew-vasquezs-computer.local>
References: <200608140946.50411.arekm@pld-linux.org> <200608141437.05269.arekm@pld-linux.org> <200608151429.09082.arekm@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:13253 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S932175AbWHPSOs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Aug 2006 14:14:48 -0400
Content-Disposition: inline
In-Reply-To: <200608151429.09082.arekm@pld-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 15 Aug 2006, Arkadiusz Miskiewicz wrote:

> On Monday 14 August 2006 14:37, Arkadiusz Miskiewicz wrote:
> > On Monday 14 August 2006 09:46, Arkadiusz Miskiewicz wrote:
> > > Hi,
> > >
> > > I was using QLA2312 FC card on 32-bit machine with 6GB ram
> > > without problems. Recently I've switched to opteron dual core machine
> > > also with 6GB ram and I'm having serious problem with access to FC array.
> > >
> > > When I switch back to 32-bit machine the problem disappears. Some qla2312
> > > problems with 64bit machines?
> >
> > I've tested latest git (same as 2.6.18rc4 I guess) using latest ql2300
> > firmware from qlogic site.
> 
> I have simply no idea what's going here :-(
> 
> Everything works fine on 32-bit dual xeon machine with card inserted into PCI 
> slot. Here in new dual core opteron machine the card sits in PCI-X slot. It's 
> Thunder K8SRE S2891 mainboard, Transport GT24 B2891 1U barebone, Tyan M2075 
> riser card, 2 x Opteron 270, 6GB ram.

Have you ruled out motherboard/memory issues?  We've run 23xx and 24xx
boards on a variety of AMD64 motherboards with more than 4GB of
memory.

> Note that booting with 32-bit kernel (which works fine on Xeon system) doesn't 
> cure the problem on Opteron system. Booting 64bit 2.6.18rc4 kernel with 
> mem=3G also doesn't fix anything.

Hmm...  Can you send your dmesg output post boot and driver load?

> /t is on tmpfs, /dev/sda2 in on FC array. Reading the same data several times 
> and I get different md5sum results each time, see below.
> 
> How I can track where corruption occurs?

Regards,
Andrew Vasquez
