From: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Sun, 10 Jul 2005 03:49:08 +0200
Message-ID: <42D07E94.8070409@drzeus.cx>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [85.8.12.41] ([85.8.12.41]:18366 "EHLO smtp.drzeus.cx")
	by vger.kernel.org with ESMTP id S261814AbVGJBtK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jul 2005 21:49:10 -0400
In-Reply-To: <20050709175725.75f291bf.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: randy_dunlap <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org

randy_dunlap wrote:

>Pierre,
>
>Can you capture the complete panic message using serial console or
>netconsole?  or at least use a smaller font on the console so that
>we can see the entire panic message, as some critical parts of it
>have scrolled off the top of the screen.
>
>  
>

Hmm... I made an attempt to get netconsole up and running but nothing is
emitted to the network. It seems to think everthing is fine though:

netconsole: local port 6665
netconsole: interface eth0
netconsole: remote port 6666
netconsole: remote IP 10.100.0.4
netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
netconsole: local IP 10.100.0.10
netconsole: network logging started

Perhaps the 3c95x driver doesn't work with netconsole?

Rgds
Pierre

