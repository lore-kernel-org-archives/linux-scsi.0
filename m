From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: aha152x(_cs) oops
Date: Fri, 28 Apr 2006 07:38:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0604280733060.4148@poirot.grange>
References: <20060413093615.661b7018.rdunlap@xenotime.net>
 <1144950036.3474.36.camel@mulgrave.il.steeleye.com>
 <20060425115709.0db4332f.rdunlap@xenotime.net> <Pine.LNX.4.60.0604252143550.3893@poirot.grange>
 <20060425140327.605f22ac.rdunlap@xenotime.net> <Pine.LNX.4.60.0604262202200.6890@poirot.grange>
 <20060426132901.ec6d0952.rdunlap@xenotime.net> <Pine.LNX.4.60.0604262312580.6890@poirot.grange>
 <20060427091937.f21c6e81.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:26787 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1030230AbWD1Fij (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 01:38:39 -0400
In-Reply-To: <20060427091937.f21c6e81.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Thu, 27 Apr 2006, Randy.Dunlap wrote:

> I built a kernel without highmem support and banged on the jaz drive
> quite a bit with it, without errors AFAICT.  I also did not see any
> evidence of "resend"s being needed, so it was a bit inconclusive.

Hm, well, I don't see a burning need in fixing this particular driver 
"properly", I think, it might do with your fix for now. I might give it a 
couple more tries but it won't be too soon and not too intensive either, 
unless someone can give good reasons for the opposite.

Thanks
Guennadi
---
Guennadi Liakhovetski
