From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: memory leak in scsi_cmd_cache 2.6.15
Date: Mon, 23 Jan 2006 07:18:18 +0100
Message-ID: <1137997104.2977.7.camel@laptopd505.fenrus.org>
References: <Pine.LNX.4.62.0601212105590.22868@pureeloreel.qftzy.pbz>
	 <1137917798.3328.2.camel@laptopd505.fenrus.org>
	 <1137918044.3328.6.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.62.0601221251340.30208@pureeloreel.qftzy.pbz>
	 <1137956841.3328.36.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.62.0601222045180.12815@pureeloreel.qftzy.pbz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51625 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964836AbWAWGS0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jan 2006 01:18:26 -0500
In-Reply-To: <Pine.LNX.4.62.0601222045180.12815@pureeloreel.qftzy.pbz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ariel <askernel2615@dsgml.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, 2006-01-22 at 21:14 -0500, Ariel wrote:
> On Sun, 22 Jan 2006, Arjan van de Ven wrote:
> >>> On Sun, 2006-01-22 at 09:16 +0100, Arjan van de Ven wrote:
> >>>> On Sat, 2006-01-21 at 21:13 -0500, Ariel wrote:
> 
> >>>>> I have a memory leak in scsi_cmd_cache.
> 
> >>>> does this happen without the binary nvidia driver too? (it appears
> >>>> you're using that). That's a good datapoint to have if so...
> 
> > please repeat this without nvidia ever being loaded. Just having a
> > module loaded before can already cause corruption that ripples through
> > later, so just unloading is not enough to get a clean result.
> 
> I rebooted without nvidia or vmware ever being loaded and got a 
> leak of 1.12KB/s. So I think we can rule that out.

great

> 
> A commonality I'm noticing is SATA. SATA had a big update in this 
> version, so perhaps that's where to start looking.

I wonder if it can be narrowed even more, like to the exact chipset
driver?

