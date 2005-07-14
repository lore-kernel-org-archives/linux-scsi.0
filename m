From: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Fri, 15 Jul 2005 00:25:02 +0200
Message-ID: <42D6E63E.4070402@drzeus.cx>
References: <20050709175725.75f291bf.rdunlap@xenotime.net> <42D07E94.8070409@drzeus.cx> <20050709210824.29a90c5b.rdunlap@xenotime.net> <42D12A39.80207@drzeus.cx> <20050710093907.3f3c36e4.rdunlap@xenotime.net> <42D15968.1080101@drzeus.cx> <20050710105635.6d1606e3.rdunlap@xenotime.net> <42D17D49.1000007@drzeus.cx> <Pine.LNX.4.60.0507132312050.8774@poirot.grange> <42D5AA82.3010304@drzeus.cx> <Pine.LNX.4.60.0507142327060.16078@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [85.8.12.41] ([85.8.12.41]:37251 "EHLO smtp.drzeus.cx")
	by vger.kernel.org with ESMTP id S262822AbVGNWZR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2005 18:25:17 -0400
In-Reply-To: <Pine.LNX.4.60.0507142327060.16078@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: randy_dunlap <rdunlap@xenotime.net>, linux-scsi@vger.kernel.org

Guennadi Liakhovetski wrote:

>>127MB HIGHMEM available.
>>896MB LOWMEM available.
>>    
>>

Quite right. The limit is slightly before 1 GB, not exactly at it. My bad.

Rgds
Pierre

