From: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Tue, 26 Jul 2005 00:21:50 +0200
Message-ID: <42E565FE.4070708@drzeus.cx>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>	<42D07E94.8070409@drzeus.cx>	<20050709210824.29a90c5b.rdunlap@xenotime.net>	<42D12A39.80207@drzeus.cx>	<20050710093907.3f3c36e4.rdunlap@xenotime.net>	<42D15968.1080101@drzeus.cx>	<20050710105635.6d1606e3.rdunlap@xenotime.net>	<42D17D49.1000007@drzeus.cx>	<Pine.LNX.4.60.0507132312050.8774@poirot.grange>	<42E03506.7030707@drzeus.cx>	<20050721235348.05eace11.rdunlap@xenotime.net>	<20050722135055.6cb4597d.rdunlap@xenotime.net>	<42E17451.6090706@drzeus.cx>	<20050722153651.28d5db51.rdunlap@xenotime.net>	<42E17772.3020903@drzeus.cx>	<20050723100945.7d43d063.rdunlap@xenotime.net>	<42E2933C.4050808@drzeus.cx>	<20050723152714.4212ba52.rdunlap@xenotime.net>	<42E2ECF1.8070501@drzeus.cx>	<20050723184014.49629f9e.rdunlap@xenotime.net>	<42E39462.3040007@drzeus.cx> <20050724100153.3e891484.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [85.8.12.41] ([85.8.12.41]:19079 "EHLO smtp.drzeus.cx")
	by vger.kernel.org with ESMTP id S261235AbVGYWVw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 18:21:52 -0400
In-Reply-To: <20050724100153.3e891484.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: randy_dunlap <rdunlap@xenotime.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Oliver Neukum <ioliver@neukum.name>, linux-scsi@vger.kernel.org

randy_dunlap wrote:

>  
>
>That's a highmem bug.  IIRC, Guennadi said that highmem does not
>(or may not) work correctly in this driver, so I should have
>asked you to test with HIGHMEM disabled so that the other bug
>can be addressed.
>
>  
>

I have now tried 2.6.12{,.1,.2} and only 2.6.12.2 breaks (without
HIGHMEM that is).

(Interested parties readded to cc)

Rgds
Pierre

