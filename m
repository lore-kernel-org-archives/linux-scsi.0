From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Patch] Fix oops on rmmod usb-storage
Date: 29 Sep 2004 11:35:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096472135.2124.27.camel@mulgrave>
References: <415A67B8.2080003@suse.de> <1096466196.2028.8.camel@mulgrave>
	<1096463876.15905.23.camel@localhost.localdomain>
	<1096467874.1762.15.camel@mulgrave> <415ACA4C.807@suse.de>
	<1096470919.1762.21.camel@mulgrave>
	<20040929152834.GH16153@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:11959 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268527AbUI2Pfr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 11:35:47 -0400
In-Reply-To: <20040929152834.GH16153@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Hannes Reinecke <hare@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-09-29 at 11:28, Matthew Wilcox wrote:
> How can this happen?  You're taking the address of dev->sdev_gendev, so it
> can't be NULL:

Just in case we link it into the device state model.

James


