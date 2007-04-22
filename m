From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: InitIO SCSI: Volunteers required
Date: Sun, 22 Apr 2007 17:22:47 +0100
Message-ID: <20070422172247.0f284e30@the-village.bc.nu>
References: <20070420103849.7358f1f1@the-village.bc.nu>
	<20070422141423.GA8928@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52967 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161371AbXDVQTQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Apr 2007 12:19:16 -0400
In-Reply-To: <20070422141423.GA8928@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: rene@exactcode.de, todorovic.s@googlemail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> This doesn't change much outside the initialization and irq code, so
> any additional de-crappyfication will hopefully apply ontop.

This will actually clash horribly with the rest of the rework, so it does
need to be applied after the other changes. The driver in my tree no
longer looks much like the driver you are hacking on because its been
turned into a Linux driver.

Its just a matter of ordering of the changes to get this merged nicely.

Don't suppose you also did the other scsi offenders ?

Alan
