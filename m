From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH][2.5] Aic7xxx and EISA API
Date: Mon, 19 May 2003 10:53:56 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1364120000.1053363235@aslan.btc.adaptec.com>
References: <wrpel2v54y9.fsf@hina.wild-wind.fr.eu.org>	<1328050000.1053359007@aslan.btc.adaptec.com>	<wrp8yt3545s.fsf@hina.wild-wind.fr.eu.org>	<1353820000.1053360902@aslan.btc.adaptec.com>	<wrpznli52iy.fsf@hina.wild-wind.fr.eu.org>	<1358650000.1053362109@aslan.btc.adaptec.com> <wrpu1bq51qq.fsf@hina.wild-wind.fr.eu.org>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:39301 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S262252AbTESQk6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 12:40:58 -0400
In-Reply-To: <wrpu1bq51qq.fsf@hina.wild-wind.fr.eu.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: mzyngier@freesurf.fr
Cc: linux-scsi@vger.kernel.org

>>>>>> "Justin" == Justin T Gibbs <gibbs@scsiguy.com> writes:
> 
> Justin> True EISA platforms will always report at slot 0.
> 
> Unfortunately not. The Alpha Jensen, despite being a pure EISA system,
> doesn't report anything in slot 0. Well, some people will argue the
> Jensen is broken in a number of ways... :-)

So treat it as a quirk by having a "root bus" driver for the Jensen
initiate the probe.  Otherwise you will never succeed in having a
generic kernel with EISA enabled.  It will just choke on lots of
PCI only systems.

--
Justin

