From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/10] aacraid: Disable device ID wildcard
Date: Fri, 4 Dec 2015 00:33:16 -0800
Message-ID: <20151204083316.GA32285@infradead.org>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1448973589-9216-9-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <566065C2.7090603@redhat.com>
 <198D06D448A18D4E93F08FB849C4E39D7D1EF169@BBYEXM01.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52560 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbbLDIdT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2015 03:33:19 -0500
Content-Disposition: inline
In-Reply-To: <198D06D448A18D4E93F08FB849C4E39D7D1EF169@BBYEXM01.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Cc: Tomas Henzl <thenzl@redhat.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Santosh Akula <Santosh.Akula@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Rich Bono <Rich.Bono@pmcs.com>

On Thu, Dec 03, 2015 at 09:32:18PM +0000, Raghava Aditya Renukunta wrote:
> This will enable us to prevent aacraid from loading for PCI devices that match
> device ID wildcards. Enabling us to use say a new driver for future devices.

This looks like a bogus reason.  The same PCI ID should always be
compatible and mathed by the same driver.  Even if you add a new driver
to expose additional feature and break these semantics there is no point
to do a) reject them conditionally on a module option and b) do this
before said driver is merged.
