From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] NCR53c406a.c warning
Date: Fri, 12 Sep 2003 15:47:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063378054.5785.1.camel@dhcp23.swansea.linux.org.uk>
References: <Pine.GSO.3.96.1030912161154.17936I-100000@delta.ds2.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc1-cwma1-5-cust4.swan.cable.ntl.com ([80.5.120.4]:51351 "EHLO
	dhcp23.swansea.linux.org.uk") by vger.kernel.org with ESMTP
	id S261723AbTILOs7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2003 10:48:59 -0400
In-Reply-To: <Pine.GSO.3.96.1030912161154.17936I-100000@delta.ds2.pg.gda.pl>
List-Id: linux-scsi@vger.kernel.org
To: "Maciej W. Rozycki" <macro@ds2.pg.gda.pl>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Geert Uytterhoeven <geert@linux-m68k.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>

On Gwe, 2003-09-12 at 15:16, Maciej W. Rozycki wrote:
>  I've encountered an ISA adapter using this chip in polled mode (no ISA
> IRQ line routed to the chip) quite recently.  But I can't say if the guy
> using it won't throw it away before final 2.6. ;-)

For a lot of these dumb controllers polled I/O seems to materially 
outperform interrupt driven I/O on SMP boxes - its true of the NCR5380
for example. We trade a ton of locking jamming the box up for a CPU
thats spending some of its time pretending to be half a scsi chip.

