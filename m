From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.13 14/14] sas-class: SCSI Host glue
Date: Mon, 12 Sep 2005 09:56:45 -0400
Message-ID: <4325891D.2020006@adaptec.com>
References: <20050910041218.29183.qmail@web51612.mail.yahoo.com> <Pine.LNX.4.63.0509101028510.4630@cuia.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:45461 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750872AbVILN4w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 09:56:52 -0400
In-Reply-To: <Pine.LNX.4.63.0509101028510.4630@cuia.boston.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rik van Riel <riel@redhat.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, James Bottomley <James.Bottomley@SteelEye.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 09/10/05 10:30, Rik van Riel wrote:
> On Fri, 9 Sep 2005, Luben Tuikov wrote:
> 
> 
>>No self respecting SAS chip would not do 64 bit DMA, or have an sg 
>>tablesize or any other limitation.
>>
>>Naturally, aic94xx has _no limitations_. :-)  But hey, our hardware just 
>>kicks a*s!
> 
> 
> That's very nice for you - but lets face it, a SAS layer
> that'll be unable to also deal with the El-Cheapo brand
> controllers isn't going to be very useful.

Yes, I agree.  Let's take them as they come.

	Luben

