From: David Miller <davem@davemloft.net>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Mon, 19 Nov 2007 14:31:15 -0800 (PST)
Message-ID: <20071119.143115.251022325.davem@davemloft.net>
References: <1195450523.7022.37.camel@pasglop>
	<20071119.003802.100741794.davem@davemloft.net>
	<1195501874.6539.5.camel@pasglop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45230
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbXKSWbQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 17:31:16 -0500
In-Reply-To: <1195501874.6539.5.camel@pasglop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: benh@kernel.crashing.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 20 Nov 2007 06:51:14 +1100

> On Mon, 2007-11-19 at 00:38 -0800, David Miller wrote:
> > From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Date: Mon, 19 Nov 2007 16:35:23 +1100
> > 
> > You could make a ____dma_cacheline_aligned and use that.
> > It seems pretty reasonable.
> 
> I was thinking about that. What archs would need it ? arm, mips, what
> else ?

The sparc32 port would need it too.

