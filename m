From: Zwane Mwaikambo <zwane@linuxpower.ca>
Subject: Re: [PATCH] fix aic7xxx probing
Date: Fri, 25 Jun 2004 10:35:30 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0406251034390.2219@montezuma.fsmlabs.com>
References: <1088117341.2174.67.camel@mulgrave>
 <Pine.LNX.4.58.0406250036000.3261@montezuma.fsmlabs.com>
 <1088170181.2217.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dragnfire.mtl.istop.com ([66.11.160.179]:17024 "EHLO
	dsl.commfireservices.com") by vger.kernel.org with ESMTP
	id S266743AbUFYOdO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2004 10:33:14 -0400
In-Reply-To: <1088170181.2217.12.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, William Lee Irwin III <wli@holomorphy.com>

On Fri, 25 Jun 2004, James Bottomley wrote:

> On Thu, 2004-06-24 at 23:56, Zwane Mwaikambo wrote:
> > This patch applied against 2.6.7-mm2 doesn't detect my PCI HBA whereas
> > 2.6.7-mm2 currently does.
>
> Thanks, had another look at the code and it seems that the meaning of
> the return value for ahc_linux_pci_init() is different depending on
> kernel version, sigh.  For < 2.4.0 it means number of boards found,
> otherwise it's zero or error.
>
> We really need to scrub this 2.2 code out of the driver, but in the
> meantime, can you test the attached? (backing out the original).  It
> just makes the return of ahc_linux_pci_init() consistent.

Doesn't detect the HBA with that patch either.
