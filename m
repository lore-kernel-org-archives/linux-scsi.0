From: Christoph Hellwig <hch@lst.de>
Subject: Re: pulling failover out of qla2xxx
Date: Fri, 16 Jan 2004 13:06:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116120644.GA12704@lst.de>
References: <B179AE41C1147041AA1121F44614F0B0598E32@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:52952 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265399AbUAPMGy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 07:06:54 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598E32@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjanv@redhat.com>, Christoph Hellwig <hch@lst.de>

> 	o Add initial ISP6312/ISP6322 definitions and checks during
> 	  board configuration.

> 	o Add new 2300/2322 IPX and 6312/6322 FLX firmwares (3.02.20):
> 	  - Remove 2300 TPX firmware from distribution.

Please add a frontend module per firmware variant instead of adding
them to qla2300.ko - the whole point of these frontend modules is to
avoid having to load unessecary firmware.

Else the update looks okay.

