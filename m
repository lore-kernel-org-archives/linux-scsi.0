From: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Fri, 29 Jul 2005 01:05:48 +0200
Message-ID: <42E964CC.5060600@drzeus.cx>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>	<20050709210824.29a90c5b.rdunlap@xenotime.net>	<42D12A39.80207@drzeus.cx>	<20050710093907.3f3c36e4.rdunlap@xenotime.net>	<42D15968.1080101@drzeus.cx>	<20050710105635.6d1606e3.rdunlap@xenotime.net>	<42D17D49.1000007@drzeus.cx>	<Pine.LNX.4.60.0507132312050.8774@poirot.grange>	<42E03506.7030707@drzeus.cx>	<20050721235348.05eace11.rdunlap@xenotime.net>	<20050722135055.6cb4597d.rdunlap@xenotime.net>	<42E17451.6090706@drzeus.cx>	<20050722153651.28d5db51.rdunlap@xenotime.net>	<42E17772.3020903@drzeus.cx>	<20050723100945.7d43d063.rdunlap@xenotime.net>	<42E2933C.4050808@drzeus.cx>	<20050723152714.4212ba52.rdunlap@xenotime.net>	<42E2ECF1.8070501@drzeus.cx>	<20050723184014.49629f9e.rdunlap@xenotime.net>	<42E39462.3040007@drzeus.cx>	<20050724100153.3e891484.rdunlap@xenotime.net>	<42E565FE.4070708@drzeus.cx>	<20050725203133.3cfa650d.rdunlap@x
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [85.8.12.41] ([85.8.12.41]:18312 "EHLO smtp.drzeus.cx")
	by vger.kernel.org with ESMTP id S261781AbVG1XFw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jul 2005 19:05:52 -0400
In-Reply-To: <20050726202058.133382c1.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: randy_dunlap <rdunlap@xenotime.net>
Cc: g.liakhovetski@gmx.de, oliver@neukum.name, linux-scsi@vger.kernel.org

randy_dunlap wrote:

>
>oh drat.  Please test 2.6.12.2 with the following patch segment
>backed out (-R, reversed).  I don't see any other patches that could
>be the cause.  If this isn't the problem, I would have to begin
>to suspect some kind of toolchain problem.
>
>  
>

It seems the blame falls solely on my shoulders. I hadn't undone one of
the patches I had previously applied when searching for the HIGHMEM bug. :(

So there is no problem with the driver without HIGHMEM enabled, 2.6.12.2
or otherwise.

I'll get on figuring out with -rc caused the HIGHMEM issue instead..

Sorry
Pierre

