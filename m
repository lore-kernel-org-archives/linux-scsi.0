From: john@grabjohn.com
Subject: Re: [RFR] a new SCSI driver
Date: Sun, 25 May 2003 12:19:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200305251119.h4PBJOal000678@81-2-122-30.bradfords.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 81-2-122-30.bradfords.org.uk ([81.2.122.30]:41088 "EHLO
	81-2-122-30.bradfords.org.uk") by vger.kernel.org with ESMTP
	id S261651AbTEYKBB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 May 2003 06:01:01 -0400
List-Id: linux-scsi@vger.kernel.org
To: john@grabjohn.com, rmk@arm.linux.org.uk
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> > Thinking ahead, by the 2.8 timescale, PATA could well be legacy hardware 
> > which could be supported only by an 'old' IDE driver, much like we already
> > have at the moment - I.E. we could remove the current 'old' IDE driver
> > sometime during the 2.7 timescale, and support SATA only via the SCSI layer.

> Rubbish.  PIO mode ATA will be around for some years to come - there
> is just too much invested there (especially in the embedded world) for 
> it to vanish this quickly.  For example, think about compact flash cards,
> many of which are still driven using PIO mode accesses in todays PDAs.

Why couldn't PDAs be served by the 'old' driver then?  Old doesn't mean obsolete.

Also embedded world != PDAs.  I was thinking more of things like PVRs, and blade
servers.  What about solid state video cameras?  Are they going to use PIO mode
ATA?

John.
