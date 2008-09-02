From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH] ahci: Add support for Promise PDC42819
Date: Tue, 2 Sep 2008 14:57:10 +0100
Message-ID: <20080902145710.2034690d@lxorguk.ukuu.org.uk>
References: <65a6ef750809020403i52228319u9e3197e4062941bc@mail.gmail.com>
	<48BD2136.1020101@garzik.org>
	<20080902125310.729b0997@lxorguk.ukuu.org.uk>
	<48BD2B37.6060000@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <48BD2B37.6060000@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Nelson <mdnelson8@gmail.com>, linux-ide@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> Refresh my memory...  what is the problem with loading pata_marvell first?

The fact its almost impossible to do with a distribution kernel. eg
you can't make it work with Fedora (see the Fedora bugs assigned to
you)

If pata_marvell should be driving these chips please remove the entries
from the ahci.c driver as I asked before.

If ahci.c should be driving them then we need the documentation for
whatever extension they use driving the ports via AHCI. Clearly there is
one as its possible under Windows.

> AFAICS, if you load pata_marvell before ahci, it will grab the PATA 
> disks and the PCI device itself.

If you have a degree in initrd-foo

Alan
