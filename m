From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: Re: two sym53c8xx.o modules
Date: Thu, 09 Oct 2003 17:44:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F858274.5030001@wanadoo.es>
References: <3F84AF3C.9050408@wanadoo.es> <Pine.LNX.4.44.0310090826290.2569-100000@logos.cnet> <20031009122428.GF11525@bitwizard.nl> <20031009123857.GC27861@parcelfarce.linux.theplanet.co.uk> <20031009131152.GG11525@bitwizard.nl> <20031009132141.GF27861@parcelfarce.linux.theplanet.co.uk> <20031009140430.GI11525@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp14.eresmas.com ([62.81.235.114]:52897 "EHLO
	smtp14.eresmas.com") by vger.kernel.org with ESMTP id S262187AbTJIPp3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Oct 2003 11:45:29 -0400
List-Id: linux-scsi@vger.kernel.org
To: Erik Mouw <erik@harddisk-recovery.com>
Cc: Matthew Wilcox <willy@debian.org>, Marcelo Tosatti <marcelo.tosatti@cyclades.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Erik Mouw wrote:

> I know (I think you even told me). The fact that I only recently
> figured out about this bug proves my point: in linux-2.4 the sym53cxx_2
> driver didn't get as much testing as it should have had. Apply my
> patch, and the driver might even get real use.

What's best approach ? to replace sym53c8xx_2/sym53c8xx.o with
sym53c8xx_2/sym53c8xx_2.o or sym53c8xx.o with sym53c8xx_old.o

:-?

