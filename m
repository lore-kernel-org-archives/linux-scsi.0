From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] SCSI: limit mode sense usage
Date: 28 Oct 2003 16:37:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067384236.11029.37.camel@patehci2>
References: <Pine.LNX.4.44L0.0310281737350.6912-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:57735 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261793AbTJ1XhU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 18:37:20 -0500
In-Reply-To: <Pine.LNX.4.44L0.0310281737350.6912-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: ronald@kuetemeier.com, patmans@us.ibm.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net

> Even the successful logfile had an odd feature.  The sd driver knew enough
> to skip both the page 3F and the page 8 MODE-SENSE(10) calls.  But then it
> went ahead and issued MODE-SENSE(6) for page 8!  Fortunately this worked
> (or rather, failed cleanly enough) for things to progress okay.  Patrick,
> can you explain that too?

I'll leave Patrick M to teach us how sd gets around to trying page 8. 
But perhaps I can here now reemphasise helpfully:

I take seeing SBC/MMC page x08 Cacheing work when SPC x3F All Pages
breaks as yet more evidence that what Windows tries first is a mode
sense for page x08, never a mode sense for page x3F.

If we hold the choice of page constant, with usb-storage, I would be
surprised to see op x1A MODE_SENSE work when op x5A MODE_SENSE_10 did
not, because aften I hear people suggesting usb-storage leans, like the
Windows Atapi driver does, more towards MMC (which prefers op x5A) and
away from SBC (which began with op x1A).

Pat LaVarre


