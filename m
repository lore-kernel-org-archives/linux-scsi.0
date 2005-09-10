From: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2.6.13 14/14] sas-class: SCSI Host glue
Date: Sat, 10 Sep 2005 10:30:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.63.0509101028510.4630@cuia.boston.redhat.com>
References: <20050910041218.29183.qmail@web51612.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56256 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1750959AbVIJOaM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Sep 2005 10:30:12 -0400
In-Reply-To: <20050910041218.29183.qmail@web51612.mail.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Luben Tuikov <luben_tuikov@adaptec.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 9 Sep 2005, Luben Tuikov wrote:

> No self respecting SAS chip would not do 64 bit DMA, or have an sg 
> tablesize or any other limitation.
> 
> Naturally, aic94xx has _no limitations_. :-)  But hey, our hardware just 
> kicks a*s!

That's very nice for you - but lets face it, a SAS layer
that'll be unable to also deal with the El-Cheapo brand
controllers isn't going to be very useful.

-- 
All Rights Reversed
