From: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Fri, 22 Jul 2005 01:51:34 +0200
Message-ID: <42E03506.7030707@drzeus.cx>
References: <20050709175725.75f291bf.rdunlap@xenotime.net> <42D07E94.8070409@drzeus.cx> <20050709210824.29a90c5b.rdunlap@xenotime.net> <42D12A39.80207@drzeus.cx> <20050710093907.3f3c36e4.rdunlap@xenotime.net> <42D15968.1080101@drzeus.cx> <20050710105635.6d1606e3.rdunlap@xenotime.net> <42D17D49.1000007@drzeus.cx> <Pine.LNX.4.60.0507132312050.8774@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [85.8.12.41] ([85.8.12.41]:24709 "EHLO smtp.drzeus.cx")
	by vger.kernel.org with ESMTP id S261902AbVGUXvm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2005 19:51:42 -0400
In-Reply-To: <Pine.LNX.4.60.0507132312050.8774@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: randy_dunlap <rdunlap@xenotime.net>, linux-scsi@vger.kernel.org

I have now tried with highmem disabled and the driver still crashes. See
the following image:

http://craffe.se/dc395x_kernel_bug.jpg

Rgds
Pierre

