From: Marc Zyngier <mzyngier@freesurf.fr>
Subject: Re: [PATCH][2.5] Aic7xxx and EISA API
Date: 19 May 2003 18:23:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <wrpznli52iy.fsf@hina.wild-wind.fr.eu.org>
References: <wrpel2v54y9.fsf@hina.wild-wind.fr.eu.org>
	<1328050000.1053359007@aslan.btc.adaptec.com>
	<wrp8yt3545s.fsf@hina.wild-wind.fr.eu.org>
	<1353820000.1053360902@aslan.btc.adaptec.com>
Reply-To: mzyngier@freesurf.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:8715 "EHLO
	young-lust.wild-wind.fr.eu.org") by vger.kernel.org with ESMTP
	id S261437AbTESQRQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 12:17:16 -0400
In-Reply-To: <1353820000.1053360902@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Justin" == Justin T Gibbs <gibbs@scsiguy.com> writes:

Justin> I would expect the EISA probe code to stop its probe short if
Justin> an EISA mainboard (Slot 0), is not detected.  This avoids
Justin> spamming PCI boards that happen to reside in what was formally
Justin> slot space.  So long as this check is disabled when
Justin> EISA_VLB_PRIMING is specified, it looks like this will work.

Unfortunately, a number of EISA plateforms (mostly non x86, though)
are not reporting anything on slot 0... So we cannot stop from wildly
probing the other slots.

Justin> There are a few other things in the patch that need to be
Justin> cleaned up before it is taken, but I will comment more
Justin> thoroughly on that when I have some more time later today.

I'll be glad to read your comments.

Thanks,

        M.
-- 
Places change, faces change. Life is so very strange.
