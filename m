From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: aha152x(_cs) oops
Date: Fri, 28 Apr 2006 07:31:53 -0700 (PDT)
Message-ID: <Pine.LNX.4.58.0604280731220.8301@shark.he.net>
References: <20060413093615.661b7018.rdunlap@xenotime.net>
 <1144950036.3474.36.camel@mulgrave.il.steeleye.com>
 <20060425115709.0db4332f.rdunlap@xenotime.net> <Pine.LNX.4.60.0604252143550.3893@poirot.grange>
 <20060425140327.605f22ac.rdunlap@xenotime.net> <Pine.LNX.4.60.0604262202200.6890@poirot.grange>
 <20060426132901.ec6d0952.rdunlap@xenotime.net> <Pine.LNX.4.60.0604262312580.6890@poirot.grange>
 <20060427091937.f21c6e81.rdunlap@xenotime.net> <Pine.LNX.4.60.0604280733060.4148@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:59084 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1030293AbWD1Obz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 10:31:55 -0400
Received: from shark.he.net ([66.160.160.2]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2006 07:31:53 -0700
In-Reply-To: <Pine.LNX.4.60.0604280733060.4148@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Fri, 28 Apr 2006, Guennadi Liakhovetski wrote:

> On Thu, 27 Apr 2006, Randy.Dunlap wrote:
>
> > I built a kernel without highmem support and banged on the jaz drive
> > quite a bit with it, without errors AFAICT.  I also did not see any
> > evidence of "resend"s being needed, so it was a bit inconclusive.
>
> Hm, well, I don't see a burning need in fixing this particular driver
> "properly", I think, it might do with your fix for now. I might give it a
> couple more tries but it won't be too soon and not too intensive either,
> unless someone can give good reasons for the opposite.

Agreed, I don't have a problem with that.

-- 
~Randy
