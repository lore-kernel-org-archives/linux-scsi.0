From: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Sun, 10 Jul 2005 19:22:48 +0200
Message-ID: <42D15968.1080101@drzeus.cx>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>	<42D07E94.8070409@drzeus.cx>	<20050709210824.29a90c5b.rdunlap@xenotime.net>	<42D12A39.80207@drzeus.cx> <20050710093907.3f3c36e4.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [85.8.12.41] ([85.8.12.41]:39102 "EHLO smtp.drzeus.cx")
	by vger.kernel.org with ESMTP id S261979AbVGJRWu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 13:22:50 -0400
In-Reply-To: <20050710093907.3f3c36e4.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: randy_dunlap <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org

I've tried to get it running on three separate machines now with no
success (each running a different kernel version), so I'm starting to
suspect I'm doing something wrong here. I've used the following line to
load the module:

modprobe netconsole netconsole=@/,@10.8.0.168/

I've tried changing the ip-address to both broadcast and specific hosts
with the same result. I also tried giving all parameters using:

modprobe netconsole
netconsole=2000@10.8.0.24/eth0,3000@10.8.0.168/00:0e:35:15:32:d6

but the result was the same.

Anything else I might be doing wrong?

Rgds
Pierre

