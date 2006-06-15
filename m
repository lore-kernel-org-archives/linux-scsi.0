From: Christoph Hellwig <hch@infradead.org>
Subject: Re: qlogic qla2312f-v2 (hp oem?)
Date: Thu, 15 Jun 2006 16:24:44 +0100
Message-ID: <20060615152444.GA4115@infradead.org>
References: <7.0.1.0.0.20060609132026.025d7098@elexis.nl> <20060614224826.GS879@andrew-vasquezs-powerbook-g4-15.local> <17053.82.92.29.80.1150370438.squirrel@webmail.elexis.nl> <1150384624.12760.137.camel@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:15850 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030674AbWFOPYt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 11:24:49 -0400
Content-Disposition: inline
In-Reply-To: <1150384624.12760.137.camel@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: sander@elexis.nl, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org

On Thu, Jun 15, 2006 at 09:17:04AM -0600, Andrew Patterson wrote:
> On Thu, 2006-06-15 at 13:20 +0200, sander@elexis.nl wrote:
> > The FAQ section on the qlogic website says this card is only sold as an
> > oem product, and that I should contact HP for drivers. However, the driver
> > packages HP has made available just seem to contain the original qla2xxx
> > drivers included in the kernel.
> > 
> 
> HP's versions of the QLogic driver may of may not be newer than the ones
> in kernel.org depending on timing.  They usually have some later bug
> fixes found when qualifying HP storage and add features that have not
> been accepted by kernel.org, e.g., multi-pathing.  These driver's
> however, have only been certified with various versions of RHEL and
> SLES, so they may not help you with other distros or if rolling your own
> kernel.

Or to say it in plain english they're the crappy old out of tree drivers
not using the proper kernel infrastructure and you should stay away from
them as far as possible.  The only reason to use them is if you have
a HP support contract and claim them liable if they don't work :)

