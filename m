From: Zwane Mwaikambo <zwane@linuxpower.ca>
Subject: Re: [PATCH] fix aic7xxx probing
Date: Fri, 25 Jun 2004 00:56:34 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0406250036000.3261@montezuma.fsmlabs.com>
References: <1088117341.2174.67.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dragnfire.mtl.istop.com ([66.11.160.179]:55168 "EHLO
	dsl.commfireservices.com") by vger.kernel.org with ESMTP
	id S266199AbUFYEyU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2004 00:54:20 -0400
In-Reply-To: <1088117341.2174.67.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, William Lee Irwin III <wli@holomorphy.com>

On Thu, 24 Jun 2004, James Bottomley wrote:

> It looks like there's still a problem with the probing:
>
> ahc_linux_pci_init() returns the number of boards attached
> ahc_linux_eisa_init() returns 0 on success or error
>
> The only reason the current code actually works on PCI seems to be that
> it's already attached the devices by the time it returns what the
> ahc_linux_detect() assumes to be a failure code.

This patch applied against 2.6.7-mm2 doesn't detect my PCI HBA whereas
2.6.7-mm2 currently does.

