From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] depends on PCI DMA API: Adaptec AIC7xxx_old
Date: 20 Jul 2004 14:53:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1090353229.1947.7.camel@mulgrave>
References: <200407201839.i6KIdo2I015550@anakin.of.borg>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:54942 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266185AbUGTTyK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2004 15:54:10 -0400
In-Reply-To: <200407201839.i6KIdo2I015550@anakin.of.borg>
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-07-20 at 13:39, Geert Uytterhoeven wrote:
> Adaptec AIC7xxx_old unconditionally depends on the PCI DMA API, so mark it
> broken if !PCI

Are you sure this is valid?  I thought it used a NULL pci device for
EISA (which I hate, but which still apparently works at least on x86).

James


