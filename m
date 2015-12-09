From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [patch RESEND] atp870u: 64 bit bug in atp885_init()
Date: Wed, 9 Dec 2015 19:37:32 +0000
Message-ID: <20151209193732.5940e706@lxorguk.ukuu.org.uk>
References: <55B9CA3B.1030205@suse.de>
	<20151209102453.GE3173@mwanda>
	<20151209115339.46a09d94@lxorguk.ukuu.org.uk>
	<20151209134512.GA5177@mwanda>
	<20151209141459.41a237c9@lxorguk.ukuu.org.uk>
	<20151209174819.GB5177@mwanda>
	<alpine.DEB.2.10.1512091907590.2491@hadrien>
	<20151209182822.GC5284@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43503 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbbLITic (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2015 14:38:32 -0500
In-Reply-To: <20151209182822.GC5284@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, "James E.J. Bottomley" <JBottomley@odin.com>, Ondrej Zary <linux@rainbow-software.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Hannes Reinecke <hare@suse.com>

> You should just delete that code along with the Kconfig and Makefile
> entries.  Don't bother moving it to staging.  The move to staging is
> supposed to give people one last chance to yell if they absolutely need
> the code.  No one has compiled this code for years so no one will miss
> it.

And for stuff which might be worth saving (eg something that looks rather
broken but has possibly got users) the driver goes into staging
in its own directory and the Makefile and Kconfig entry for it move into
the staging directory with the hope that someone screams and maintains it.

Alan

