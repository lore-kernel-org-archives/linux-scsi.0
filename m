From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: What still uses the block layer?
Date: Tue, 16 Oct 2007 22:18:19 +0200
Message-ID: <47151C8B.5050704@s5r6.in-berlin.de>
References: <200710112011.22000.rob@landley.net> <200710141836.55211.rob@landley.net> <4712FE33.3000400@s5r6.in-berlin.de> <200710150426.04924.rob@landley.net> <20071015160800.GA324@parisc-linux.org> <47139F15.7050702@s5r6.in-berlin.de> <Pine.LNX.4.64.0710151954550.3949@asgard.lang.hm> <20071016111911.30a18e12@the-village.bc.nu> <Pine.LNX.4.64.0710161238140.6995@asgard.lang.hm> <20071016195432.GA31306@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:40325 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbXJPUS4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 16:18:56 -0400
In-Reply-To: <20071016195432.GA31306@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: david@lang.hm, Alan Cox <alan@lxorguk.ukuu.org.uk>, Rob Landley <rob@landley.net>, David Newall <david@davidnewall.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

Matthew Wilcox wrote:
> On Tue, Oct 16, 2007 at 12:54:58PM -0700, david@lang.hm wrote:
>> On Tue, 16 Oct 2007, Alan Cox wrote:
>>> I wouldn't try dividing those by pata v sata. You'll cause all sorts of
>>> problems in the process because of PATA-SATA and SATA-PATA bridges.
>> if you use a PATA-SATA bridge (IDE drive SATA controller), it would look 
>> to the system like a SATA drive and be addressed and enumerated as SATA.
> 
> But you don't know where the bridge is.  It might be on the drive's
> board, it might be an explicit enclosure, or it might be on the
> motherboard.  Each of those scenarios is going to have a different user
> expectation.

If the bridge is on the drive's board or in an enclosure, the user's
expectations are fully met.

If the bridge is on the motherboard, then the user may be surprised
unless he knows the motherboard well enough.

But this is _far_ less of an issue than
  - the hda<->sda confusion,
  - the confusion caused by all kernel default names put into a single
    namespace.

I don't have a personal interest in PATA/SATA distinction though.  I
suppose once PATA went into the SCSI namespace and then this namespace
is divided again, it's not a big issue anymore whether PATA and SATA
share an ATA namespace or are distinct, except perhaps for people with
IDE drive and eSATA slots.
-- 
Stefan Richter
-=====-=-=== =-=- =----
http://arcgraph.de/sr/
