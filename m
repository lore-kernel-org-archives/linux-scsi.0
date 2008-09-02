From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH] ahci: Add support for Promise PDC42819
Date: Tue, 2 Sep 2008 12:53:10 +0100
Message-ID: <20080902125310.729b0997@lxorguk.ukuu.org.uk>
References: <65a6ef750809020403i52228319u9e3197e4062941bc@mail.gmail.com>
	<48BD2136.1020101@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <48BD2136.1020101@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Mark Nelson <mdnelson8@gmail.com>, linux-ide@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> > Apparently this chip also supports SAS disks, will these work with the
> > ahci driver (I've only tested with normal desktop SATA disks)?
> 
> ahci is definitely SATA-only, so I wonder how they modified AHCI to 
> support SAS transport...

Jeff while are on that subject a further reminder - AHCI is also breaking
Marvell PATA device support for this reason and we now have months of
regressions because of that.
