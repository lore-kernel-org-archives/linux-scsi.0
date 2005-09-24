From: Mark Lord <liml@rtr.ca>
Subject: Re: Supporting ACPI drive hotswap
Date: Sat, 24 Sep 2005 15:45:45 -0400
Message-ID: <4335ACE9.7070009@rtr.ca>
References: <20050924164823.GA24351@srcf.ucam.org> <20050924124050.1955c290.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750718AbVIXTpt@vger.kernel.org>
In-Reply-To: <20050924124050.1955c290.rdunlap@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, acpi-support@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

 >Do you know why the ahci driver won't load?

Undoubtedly the chip is being used in "combined mode",
to support a PATA ATAPI device on the second channel.

For that matter, the primary HD is probably actually PATA,
perhaps with a SATA bridge on the notebook M/B.

Very very common arrangement these days -- practically all
Sonoma Centrino chipset notebooks are set up like this.

Cheers
