From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 23:01:37 +0100
Message-ID: <20071015230137.3cdbeb71@the-village.bc.nu>
References: <200710112011.22000.rob@landley.net>
	<200710150304.00901.rob@landley.net>
	<18195.19678.500863.613193@notabene.brown>
	<200710151634.57407.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51149 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757002AbXJOV6g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 17:58:36 -0400
In-Reply-To: <200710151634.57407.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: Neil Brown <neilb@suse.de>, Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

> This is where we disagree.  The existence of devices you cannot stably 
> enumerate does not eliminate the existence of devices you trivially can.

"trivially" 

You are I assume familiar in full with EDD 3.0, EDD 1.x and the Ralf
Brown documentation on the BIOS drive mappings and tables for different
BIOSes ?

If you are then you could add EDD 1.x spport, FADT parsing and update the
EDD driver to produce links to the drives in BIOS map order. Would be
quite useful but very few people on the planet actually know all the
arcana to do this.

Alan
