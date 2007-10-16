From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: What still uses the block layer?
Date: Tue, 16 Oct 2007 22:49:25 +0100
Message-ID: <20071016224925.07d28c48@the-village.bc.nu>
References: <200710112011.22000.rob@landley.net>
	<200710141836.55211.rob@landley.net>
	<4712FE33.3000400@s5r6.in-berlin.de>
	<200710150426.04924.rob@landley.net>
	<20071015160800.GA324@parisc-linux.org>
	<47139F15.7050702@s5r6.in-berlin.de>
	<Pine.LNX.4.64.0710151954550.3949@asgard.lang.hm>
	<20071016111911.30a18e12@the-village.bc.nu>
	<Pine.LNX.4.64.0710161238140.6995@asgard.lang.hm>
	<20071016195432.GA31306@parisc-linux.org>
	<Pine.LNX.4.64.0710161302460.6995@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S966379AbXJPVrk@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0710161302460.6995@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
To: david@lang.hm
Cc: Matthew Wilcox <matthew@wil.cx>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Rob Landley <rob@landley.net>, David Newall <david@davidnewall.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org

> but in any case, historicly IDE (PATA) and SATA drives have been handled 
> differently, IDE drives have had fixed device names based on how they are 
> connected, SATA devices have had 'order found' device names from the SCSI 

Nope.

Historically it depended whether you had a PATA controller with SATA
bridge, a SATA controller with SATA drives, a PATA controller with PATA
drives or a SATA controller with PATA bridge.

Often the bridges are on the card or mainboard. So some VIA systems would
historically use /dev/hda for the first SATA device.

Even more fun is stuff like Jmicron where the BIOS settings determined
whether PATA or SATA was /dev/hda

Alan
