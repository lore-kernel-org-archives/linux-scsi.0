From: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Fw: Kernel panic with dc395x in 2.6.12.2
Date: Sun, 10 Jul 2005 16:01:29 +0200
Message-ID: <42D12A39.80207@drzeus.cx>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>	<42D07E94.8070409@drzeus.cx> <20050709210824.29a90c5b.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [85.8.12.41] ([85.8.12.41]:31934 "EHLO smtp.drzeus.cx")
	by vger.kernel.org with ESMTP id S261936AbVGJOBb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 10:01:31 -0400
In-Reply-To: <20050709210824.29a90c5b.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: randy_dunlap <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org

randy_dunlap wrote:

>3c59x ??
>3c59x.c has CONFIG_NET_POLL_CONTROLLER code in it.
>I would expect it to work since it's a fairly common NIC, but I
>can't vouch for it.
>Did you enable CONFIG_NETPOLL in your kernel .config?
>
>  
>

Yup. It's enabled. NETPOLL_RX is not enabled though. Is that needed?
Netconsole is also built as a module so that I can easily fiddle around
with the parameters. Any known problems there?

Rgds
Pierre

