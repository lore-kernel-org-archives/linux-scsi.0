From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [2.6 patch] let AIC7{9,X}XX_BUILD_FIRMWARE depend
	on!PREVENT_FIRMWARE_BUILD
Date: 03 Aug 2004 12:31:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1091561517.1942.0.camel@mulgrave>
References: <20040801185543.GB2746@fs.tum.de>
	<20040801191118.GA7402@mars.ravnborg.org> <410FA577.4040602@adaptec.com>
	<410FBDAA.4070907@optonline.net>
	<1091550985.2816.10.camel@laptop.fenrus.com>  <410FD035.6080905@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-64-109-89-108.dsl.chcgil.ameritech.net ([64.109.89.108]:45514
	"EHLO redscar") by vger.kernel.org with ESMTP id S266807AbUHCTb7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Aug 2004 15:31:59 -0400
In-Reply-To: <410FD035.6080905@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Arjan van de Ven <arjanv@redhat.com>, Nathan Bryant <nbryant@optonline.net>, Sam Ravnborg <sam@ravnborg.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Adrian Bunk <bunk@fs.tum.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, 2004-08-03 at 10:49, Luben Tuikov wrote:
> Yes, no problem.  Whatever you guys want.
> I can provide small incremental patches (right out of
> perforce), and generate incremantal BKs (will have to look into
> that).

Actually, small incremental patches across the scsi list is what I'd
prefer.  I can take care of doing the BK stuff to pull the patches
straight off the list.

James


