From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: dtc, pas16 and t128 removal, was Re: status of NCR5380-based
 ISA drivers
Date: Mon, 12 Sep 2016 10:29:24 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1609121024070.22548@nippy.intranet>
References: <20160911171249.GA7554@infradead.org> <alpine.LNX.2.00.1609120927530.21469@nippy.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49466 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932252AbcILA3Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2016 20:29:24 -0400
In-Reply-To: <alpine.LNX.2.00.1609120927530.21469@nippy.intranet>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org


On Mon, 12 Sep 2016, I wrote:

> 
> BTW, DTC3x80 support (NCR 53C406 chip I believe) should be easy to do in 
> g_NCR5380, which already supports the DTC3181E card.
> 

Sorry, I should have written DTC406 chip, which is "supposedly compatible 
with the NCR 53C400" but is nothing like a NCR 53C406.

-- 
