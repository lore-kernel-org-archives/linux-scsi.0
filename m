From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: [RFR] a new SCSI driver
Date: Sun, 25 May 2003 10:35:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030525103553.A26555@flint.arm.linux.org.uk>
References: <200305250944.h4P9i5Ct000456@81-2-122-30.bradfords.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:6411 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S261566AbTEYJWr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 May 2003 05:22:47 -0400
Content-Disposition: inline
In-Reply-To: <200305250944.h4P9i5Ct000456@81-2-122-30.bradfords.org.uk>; from john@grabjohn.com on Sun, May 25, 2003 at 10:44:05AM +0100
List-Id: linux-scsi@vger.kernel.org
To: john@grabjohn.com
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com, linux-scsi@vger.kernel.org

On Sun, May 25, 2003 at 10:44:05AM +0100, john@grabjohn.com wrote:
> Thinking ahead, by the 2.8 timescale, PATA could well be legacy hardware 
> which could be supported only by an 'old' IDE driver, much like we already
> have at the moment - I.E. we could remove the current 'old' IDE driver
> sometime during the 2.7 timescale, and support SATA only via the SCSI layer.

Rubbish.  PIO mode ATA will be around for some years to come - there
is just too much invested there (especially in the embedded world) for
it to vanish this quickly.  For example, think about compact flash cards,
many of which are still driven using PIO mode accesses in todays PDAs.

(and in some PDAs, there isn't the hardware facilities to even think
about trying any type of DMA transfer.)

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

