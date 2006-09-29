From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.18-mm2
Date: Sat, 30 Sep 2006 00:43:24 +0100
Message-ID: <1159573404.13029.96.camel@localhost.localdomain>
References: <20060928014623.ccc9b885.akpm@osdl.org>
	 <20060929155738.7076f0c8@werewolf> <20060929143949.GL5017@parisc-linux.org>
	 <1159550143.13029.36.camel@localhost.localdomain>
	 <20060929235054.GB2020@slug>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41103 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP id S932243AbWI2XS3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Sep 2006 19:18:29 -0400
In-Reply-To: <20060929235054.GB2020@slug>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: Matthew Wilcox <matthew@wil.cx>, "J.A. Magall??n" <jamagallon@ono.com>, Andrew Morton <akpm@osdl.org>, "Linux-Kernel," <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Ar Gwe, 2006-09-29 am 23:50 +0000, ysgrifennodd Frederik Deweerdt:
> Does this patch makes sense in that case? If yes, I'll put up a patch
> for the remaining cases in the drivers/scsi/aic7xxx/ directory.
> Also, aic7xxx's coding style would put parenthesis around the returned
> value, should I follow it?

Yes - but perhaps with a warning message so users know why ?

As to coding style - kernel style is unbracketed so I wouldnt worry
about either.


