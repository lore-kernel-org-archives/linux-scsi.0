From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH][2.5] Aic7xxx and EISA API
Date: Mon, 19 May 2003 10:35:09 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1358650000.1053362109@aslan.btc.adaptec.com>
References: <wrpel2v54y9.fsf@hina.wild-wind.fr.eu.org>	<1328050000.1053359007@aslan.btc.adaptec.com>	<wrp8yt3545s.fsf@hina.wild-wind.fr.eu.org>	<1353820000.1053360902@aslan.btc.adaptec.com> <wrpznli52iy.fsf@hina.wild-wind.fr.eu.org>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:62608 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S261624AbTESQWP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 12:22:15 -0400
In-Reply-To: <wrpznli52iy.fsf@hina.wild-wind.fr.eu.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: mzyngier@freesurf.fr
Cc: linux-scsi@vger.kernel.org

> Unfortunately, a number of EISA plateforms (mostly non x86, though)
> are not reporting anything on slot 0... So we cannot stop from wildly
> probing the other slots.

True EISA platforms will always report at slot 0.  For the PCI-EISA
bridge case, you should also perform the probe if a bridge is detected.
Doesn't that cover all of the bases in x86 land?

--
Justin

