From: Finn Thain <fthain@telegraphics.com.au>
Subject: dtc, pas16 and t128 removal, was Re: status of NCR5380-based ISA
 drivers
Date: Mon, 12 Sep 2016 09:52:04 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1609120927530.21469@nippy.intranet>
References: <20160911171249.GA7554@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49024 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755354AbcIKXwI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2016 19:52:08 -0400
In-Reply-To: <20160911171249.GA7554@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org


On Sun, 11 Sep 2016, Christoph Hellwig wrote:

> Hi all,
> 
> you seem to the currently active NCR580 cabal.  Which frontends to 
> NCR5380 do you test at the moment, or could you test?

I test the dmx3191d and mac_scsi drivers.

> 
> NCR5380-based ISA drivers make up a significant part of those drivers 
> still using scsi_module.c after it's 15 year deprecation period, and I'd 
> like to either move them to this century or to the dust bin.
> 
> The drivers in question are: dtc, g_NCR5380, pas16 and t128.

I don't have any hardware with an ISA slot so I take a best-effort 
approach to maintaining those drivers.

I have not heard of anyone actually using dtc, pas16 or t128 so I don't 
mind seeing them removed (along with Documentation/scsi/dtc3x80.txt).

BTW, DTC3x80 support (NCR 53C406 chip I believe) should be easy to do in 
g_NCR5380, which already supports the DTC3181E card.

-- 

> 
> Thanks,
> 	Christoph
