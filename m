From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: libata driver update posted
Date: Sat, 19 Jul 2003 16:13:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F19A651.2080503@pobox.com>
References: <3F1711C8.6040207@pobox.com>	 <Pine.LNX.4.53.0307180924020.19703@hosting.rdsbv.ro>	 <3F17F28C.9050105@pobox.com>	 <1058542771.13515.1599.camel@workshop.saharacpt.lan>	 <20030718154322.GB27152@gtf.org> <1058645294.23174.7.camel@nosferatu.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:39613 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S270502AbTGST6S
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jul 2003 15:58:18 -0400
In-Reply-To: <1058645294.23174.7.camel@nosferatu.lan>
List-Id: linux-scsi@vger.kernel.org
To: azarah@gentoo.org
Cc: Catalin BOIE <util@deuroconsult.ro>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Vojtech Pavlik <vojtech@suse.cz>

Martin Schlemmer wrote:
> On Fri, 2003-07-18 at 17:43, Jeff Garzik wrote:
> 
> Slower this side.  The Maxtor 40GB (ata133) is however just set to
> udma33, where the Seagate 20GB (ata100) driver is set correctly to
> udma100.

Yeah, that's expected:  Parallel ATA (PATA) requires cable detection to 
go beyond UDMA/33, and my driver doesn't do that yet [since I'm 
concentrating on SATA].


> The Seagate start off ok (about 35mb/s), but then after doing some heavy
> disk io, it also just drops to the 20mb/s region.

That's definitely interesting.  Is "heavy disk I/O" the hdparm stuff you 
described, or something else too?

	Jeff



