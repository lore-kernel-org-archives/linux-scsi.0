From: Marc Zyngier <mzyngier@freesurf.fr>
Subject: Re: [PATCH][2.5] Aic7xxx and EISA API
Date: 19 May 2003 18:40:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <wrpu1bq51qq.fsf@hina.wild-wind.fr.eu.org>
References: <wrpel2v54y9.fsf@hina.wild-wind.fr.eu.org>
	<1328050000.1053359007@aslan.btc.adaptec.com>
	<wrp8yt3545s.fsf@hina.wild-wind.fr.eu.org>
	<1353820000.1053360902@aslan.btc.adaptec.com>
	<wrpznli52iy.fsf@hina.wild-wind.fr.eu.org>
	<1358650000.1053362109@aslan.btc.adaptec.com>
Reply-To: mzyngier@freesurf.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lopsy-lu.misterjones.org ([62.4.18.26]:31755 "EHLO
	young-lust.wild-wind.fr.eu.org") by vger.kernel.org with ESMTP
	id S261798AbTESQeL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 12:34:11 -0400
In-Reply-To: <1358650000.1053362109@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

>>>>> "Justin" == Justin T Gibbs <gibbs@scsiguy.com> writes:

Justin> True EISA platforms will always report at slot 0.

Unfortunately not. The Alpha Jensen, despite being a pure EISA system,
doesn't report anything in slot 0. Well, some people will argue the
Jensen is broken in a number of ways... :-)

Justin> For the PCI-EISA bridge case, you should also perform the
Justin> probe if a bridge is detected.

This is done thanks to the pci_eisa root driver.

Justin> Doesn't that cover all of the bases in x86 land?

The EISA core code is not x86 centric. It is currently working on x86,
Alpha, and PA-RISC (I also have the bits ready for the Indigo-2, if it
ever runs 2.5).

        M.
-- 
Places change, faces change. Life is so very strange.
