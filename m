From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH][2.5] Aic7xxx and EISA API
Date: Mon, 19 May 2003 10:15:02 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1353820000.1053360902@aslan.btc.adaptec.com>
References: <wrpel2v54y9.fsf@hina.wild-wind.fr.eu.org>	<1328050000.1053359007@aslan.btc.adaptec.com> <wrp8yt3545s.fsf@hina.wild-wind.fr.eu.org>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:64655 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S261322AbTESQCF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 12:02:05 -0400
In-Reply-To: <wrp8yt3545s.fsf@hina.wild-wind.fr.eu.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: mzyngier@freesurf.fr
Cc: linux-scsi@vger.kernel.org

> No, VLB cards are treated as EISA cards in the core EISA code. You
> have to enable CONFIG_EISA_VLB_PRIMING though :

I would expect the EISA probe code to stop its probe short if an EISA
mainboard (Slot 0), is not detected.  This avoids spamming PCI boards
that happen to reside in what was formally slot space.  So long as this
check is disabled when EISA_VLB_PRIMING is specified, it looks like this
will work.

There are a few other things in the patch that need to be cleaned up before
it is taken, but I will comment more thoroughly on that when I have some
more time later today.

--
Justin

