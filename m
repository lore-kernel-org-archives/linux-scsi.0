From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: dc395x: Report
Date: Wed, 2 Aug 2006 12:11:00 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0608021209310.5115@poirot.grange>
References: <44CF40F2.3080401@annessi.at> <Pine.LNX.4.60.0608020046510.8659@poirot.grange>
 <44D075A2.2080501@annessi.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.21]:14730 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1750735AbWHBKKl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2006 06:10:41 -0400
In-Reply-To: <44D075A2.2080501@annessi.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Annessi <robert@annessi.at>
Cc: linux-scsi@vger.kernel.org

On Wed, 2 Aug 2006, Robert Annessi wrote:

> On 08/02/06 01:24, Guennadi Liakhovetski wrote:
> > a) uncommenting the line
> > 
> > #define DC395x_NO_TAGQ
> 
> I forgot to mention:
> Using this workaround works with 2.6.16 and does not trigger bug().

Yes, this is only present in 2.6.18. And what transfer rates are you 
getting with this workaround without safe=1? Compared to safe=1 and to 
other controllers / drivers?

Thanks
Guennadi
---
Guennadi Liakhovetski
