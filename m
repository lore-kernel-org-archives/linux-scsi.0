From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged
Date: Sat, 2 Oct 2004 01:46:35 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0410020144370.23298@poirot.grange>
References: <Pine.LNX.4.60.0409051654460.3039@poirot.grange>
 <1094398979.10977.9.camel@mulgrave> <20040905173134.A31521@infradead.org>
 <1094422949.10977.15.camel@mulgrave> <Pine.LNX.4.60.0409061042240.6252@poirot.grange>
 <Pine.LNX.4.60.0409061143020.8550@poirot.grange> <20040906110150.A4845@infradead.org>
 <Pine.LNX.4.60.0409061400560.1676@poirot.grange> <Pine.LNX.4.60.0410012253460.3951@poirot.grange>
 <20041001233554.B8853@infradead.org> <20041001234606.A9024@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:49064 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S267330AbUJBHSS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Oct 2004 03:18:18 -0400
In-Reply-To: <20041001234606.A9024@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 1 Oct 2004, Christoph Hellwig wrote:

> And while we're at it: The whole inquiry sniffing in dc390_SRBdone (aka all
> uses of ptr and ptr) can easily go away if you kill pDCB->Inquiry7 and check
> sdev->sdtr instead.

You once already suggested that - I didn't forget, it's a separate 
patch:-) It'll follow, but after "internal queuing removal."

Thanks
Guennadi
---
Guennadi Liakhovetski

