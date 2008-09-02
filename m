From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH] ahci: Add support for Promise PDC42819
Date: Tue, 2 Sep 2008 23:18:32 +0100
Message-ID: <20080902231832.5cb41818@lxorguk.ukuu.org.uk>
References: <65a6ef750809020403i52228319u9e3197e4062941bc@mail.gmail.com>
	<48BD2136.1020101@garzik.org>
	<20080902125310.729b0997@lxorguk.ukuu.org.uk>
	<48BD2B37.6060000@garzik.org>
	<20080902145710.2034690d@lxorguk.ukuu.org.uk>
	<48BD9282.702@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <48BD9282.702@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Nelson <mdnelson8@gmail.com>, linux-ide@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>> Situation before ahci mod:
> 
> 	Users with PATA may use pata_marvell.
> 	Users wanting SATA screwed.

WRONG as I've said repeatedly. pata_marvell handles the SATA ports too as
legacy

> Just switch the order of 'ahci' and 'pata_marvell' in 
> /etc/modprobe.conf, then use Fedora's tools regenerate the initrd.

> See?  It's not rocket science, and the current configuration can be 
> easily made to work for Fedora users.

Well they don't seem to be able to work it out, and your basic premise is
incorrect anyway. Both ports work with pata_marvell.
