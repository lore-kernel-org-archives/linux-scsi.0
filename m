From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [OT] Iomega Zip external power supply polarity?
Date: Tue, 26 Oct 2004 01:03:55 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0410260056320.24570@poirot.grange>
References: <OFC2901EBB.BD57E7EB-ON88256F38.006EFB5A-88256F38.006F5A64@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:54160 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262116AbUJZFmz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 01:42:55 -0400
In-Reply-To: <OFC2901EBB.BD57E7EB-ON88256F38.006EFB5A-88256F38.006F5A64@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 25 Oct 2004, Bryan Henderson wrote:

> >I've got an external 100MB Iomega Zip without a power supply.  On the box 
> 
> >it says just 5V, but what polarity?  Is it plus or minus on the internal 
> >pin?  Would it tolerate 4.5 / 6V, or does it need exactly 5?
> 
> Coincidentally, I found one of these in a box last week and noticed that 
> it doesn't have its power requirements labelled (which is not unusual for 
> most people, but I make it a point of labelling my stuff).  Fortunately, 
> the power supply that came with it was in the box too.  It's center 
> positive.
> It has a 1 ampere capacity.  It doesn't appear to be a regulated power 
> supply.

Thanks very much! Just checked - seems to work - at least makes the 
"correct" noise on disk insertion, not like the one, that one gets when 
reversing the polarity:-) Now just have to get myself a (standard) DB25 / 
50 Sub-D cable.

Thanks
Guennadi
---
Guennadi Liakhovetski

