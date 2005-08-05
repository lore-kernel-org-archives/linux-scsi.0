From: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Fri, 05 Aug 2005 16:32:51 +0200
Message-ID: <42F37893.30006@drzeus.cx>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>	<20050710093907.3f3c36e4.rdunlap@xenotime.net>	<42D15968.1080101@drzeus.cx>	<20050710105635.6d1606e3.rdunlap@xenotime.net>	<42D17D49.1000007@drzeus.cx>	<Pine.LNX.4.60.0507132312050.8774@poirot.grange>	<42E03506.7030707@drzeus.cx>	<20050721235348.05eace11.rdunlap@xenotime.net>	<20050722135055.6cb4597d.rdunlap@xenotime.net>	<42E17451.6090706@drzeus.cx>	<20050722153651.28d5db51.rdunlap@xenotime.net>	<42E17772.3020903@drzeus.cx>	<20050723100945.7d43d063.rdunlap@xenotime.net>	<42E2933C.4050808@drzeus.cx>	<20050723152714.4212ba52.rdunlap@xenotime.net>	<42E2ECF1.8070501@drzeus.cx>	<20050723184014.49629f9e.rdunlap@xenotime.net>	<42E39462.3040007@drzeus.cx>	<20050724100153.3e891484.rdunlap@xenotime.net>	<42E565FE.4070708@drzeus.cx>	<20050725203133.3cfa650d.rdunlap@xenotime.net>	<42E6A5C3.6070501@drzeus.cx>	<20050726202058.133382c1.rdunlap
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [85.8.12.41] ([85.8.12.41]:52875 "EHLO smtp.drzeus.cx")
	by vger.kernel.org with ESMTP id S261848AbVHEOdY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Aug 2005 10:33:24 -0400
In-Reply-To: <20050728201339.216ab3b8.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: g.liakhovetski@gmx.de, oliver@neukum.name, linux-scsi@vger.kernel.org

Ok, I've now figured out where the bug appears. 2.6.12-rc4 runs fine
while -rc5 does not.

Rgds
Pierre

