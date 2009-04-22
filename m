From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Date: Wed, 22 Apr 2009 16:18:56 +0100
Message-ID: <20090422161856.1251f8a0@lxorguk.ukuu.org.uk>
References: <20090422090929.GA14928@havoc.gtf.org>
	<49EEE225.3010700@garzik.org>
	<49EF0A92.1070400@panasas.com>
	<49EF337F.1030804@ngrt.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49EF337F.1030804@ngrt.de>
Sender: linux-ide-owner@vger.kernel.org
To: Daniela Engert <dani@ngrt.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

> Don't forget, there are ATAPI devices (some Sony CD burners and old 
> phase-changers come into mind) which *do* have multiple LUNs sitting 
> beyond the PATA port. I don't know if libata supports such setups (my 
> old OS/2 driver does) but one shouldn't hijack LUNs to emulate targets.

It's a long time ago since I tested it but my 5 CD changer was correctly
supported by libata (or more accurately by sr...).

