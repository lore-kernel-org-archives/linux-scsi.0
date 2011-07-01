From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Fri, 01 Jul 2011 14:04:41 -0500
Message-ID: <1309547081.2722.33.camel@mulgrave>
References: <20110615112016.GA4227@osiris.boeblingen.de.ibm.com>
	 <20110616160155.GB3843@osiris.boeblingen.de.ibm.com>
	 <1308242275.2436.56.camel@mulgrave>
	 <20110616184023.GA2362@osiris.boeblingen.de.ibm.com>
	 <20110620153021.GA2572@osiris.boeblingen.de.ibm.com>
	 <CAL1RGDVFR5eYHOX-jiUrU4_Ezw19FzNcCcyo0qKNYictK5He5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59927 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755293Ab1GATEo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2011 15:04:44 -0400
In-Reply-To: <CAL1RGDVFR5eYHOX-jiUrU4_Ezw19FzNcCcyo0qKNYictK5He5g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

On Fri, 2011-07-01 at 11:07 -0700, Roland Dreier wrote:
> We seem to be hitting something similar, running 2.6.39.2.
> Did anyone make any progress on this?  (I'm happy to try and
> gather more info but I probably won't be able to seriously
> debug until next week)

The first obvious question is does it reproduce with git HEAD?  If yes,
then it's an unfixed reference bug, if no, we forgot to backport the fix
(we should be able to find it easily enough).

James


