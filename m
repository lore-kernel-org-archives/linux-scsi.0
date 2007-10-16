From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: What still uses the block layer?
Date: Tue, 16 Oct 2007 11:19:11 +0100
Message-ID: <20071016111911.30a18e12@the-village.bc.nu>
References: <200710112011.22000.rob@landley.net>
	<200710141836.55211.rob@landley.net>
	<4712FE33.3000400@s5r6.in-berlin.de>
	<200710150426.04924.rob@landley.net>
	<20071015160800.GA324@parisc-linux.org>
	<47139F15.7050702@s5r6.in-berlin.de>
	<Pine.LNX.4.64.0710151954550.3949@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57261 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759454AbXJPKRx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 06:17:53 -0400
In-Reply-To: <Pine.LNX.4.64.0710151954550.3949@asgard.lang.hm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david@lang.hm
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Matthew Wilcox <matthew@wil.cx>, Rob Landley <rob@landley.net>, David Newall <david@davidnewall.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

> > /dev/sd-ide-b	- second IDE HDD,
> > /dev/sr-sata-0	- first SATA CD-ROM,

I wouldn't try dividing those by pata v sata. You'll cause all sorts of
problems in the process because of PATA-SATA and SATA-PATA bridges.
