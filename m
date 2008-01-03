From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] Remove of old NCR53C9x/esp family of drivers
Date: Thu, 03 Jan 2008 12:16:29 -0600
Message-ID: <1199384189.3122.22.camel@localhost.localdomain>
References: <477CFC97.2010201@panasas.com>  <477D0209.2000609@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44669 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272AbYACSQr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2008 13:16:47 -0500
In-Reply-To: <477D0209.2000609@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, "David S. Miller" <davem@davemloft.net>, Linux/m68k <linux-m68k@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>


On Thu, 2008-01-03 at 17:40 +0200, Boaz Harrosh wrote:
> As recommended by Christoph Hellwig. There is no use
>  of Fixing these drivers, since there is a much simpler
>  and modern esp infrastructure with David Miller's esp_scsi
> 
>   - Remove all driver files dependent on NCR53C9x.c
>         deleted:    drivers/scsi/NCR53C9x.c
>         deleted:    drivers/scsi/NCR53C9x.h
>         deleted:    drivers/scsi/blz1230.c
>         deleted:    drivers/scsi/blz2060.c
>         deleted:    drivers/scsi/cyberstorm.c
>         deleted:    drivers/scsi/cyberstormII.c
>         deleted:    drivers/scsi/dec_esp.c
>         deleted:    drivers/scsi/fastlane.c
>         deleted:    drivers/scsi/mac_esp.c
>         deleted:    drivers/scsi/mca_53c9x.c
>         deleted:    drivers/scsi/oktagon_esp.c
>         deleted:    drivers/scsi/oktagon_io.S
>         deleted:    drivers/scsi/sun3x_esp.c
> 
>   - Remove above list from drivers/scsi/Kconfig &&
> drivers/scsi/Makefile

OK, I'll split this into four pieces for scsi-pending, since there are
three separate interest groups with signoffs to collect (MCA, m68k and
alpha) plus the core removal.

James


