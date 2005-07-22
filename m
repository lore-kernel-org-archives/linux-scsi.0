From: randy_dunlap <rdunlap@xenotime.net>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Thu, 21 Jul 2005 23:53:48 -0700
Message-ID: <20050721235348.05eace11.rdunlap@xenotime.net>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>
	<42D07E94.8070409@drzeus.cx>
	<20050709210824.29a90c5b.rdunlap@xenotime.net>
	<42D12A39.80207@drzeus.cx>
	<20050710093907.3f3c36e4.rdunlap@xenotime.net>
	<42D15968.1080101@drzeus.cx>
	<20050710105635.6d1606e3.rdunlap@xenotime.net>
	<42D17D49.1000007@drzeus.cx>
	<Pine.LNX.4.60.0507132312050.8774@poirot.grange>
	<42E03506.7030707@drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chretien.genwebhost.com ([209.59.175.22]:35229 "EHLO
	chretien.genwebhost.com") by vger.kernel.org with ESMTP
	id S261950AbVGVGx5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jul 2005 02:53:57 -0400
In-Reply-To: <42E03506.7030707@drzeus.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org

On Fri, 22 Jul 2005 01:51:34 +0200 Pierre Ossman wrote:

> I have now tried with highmem disabled and the driver still crashes. See
> the following image:
> 
> http://craffe.se/dc395x_kernel_bug.jpg

Hi Pierre,

Does this happen on every boot?

Please send your .config file (or put it on craffe.se).

Does this happen with othe kernel versions?

---
~Randy
