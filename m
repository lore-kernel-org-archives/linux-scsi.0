From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFR] a new SCSI driver
Date: 27 May 2003 01:52:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1053996727.17151.47.camel@dhcp22.swansea.linux.org.uk>
References: <200305250944.h4P9i5Ct000456@81-2-122-30.bradfords.org.uk>
	 <20030525103553.A26555@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:19148
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S262257AbTE0BhM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 May 2003 21:37:12 -0400
In-Reply-To: <20030525103553.A26555@flint.arm.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: john@grabjohn.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jgarzik@pobox.com, linux-scsi@vger.kernel.org

On Sul, 2003-05-25 at 10:35, Russell King wrote:
> Rubbish.  PIO mode ATA will be around for some years to come - there
> is just too much invested there (especially in the embedded world) for
> it to vanish this quickly.  For example, think about compact flash cards,
> many of which are still driven using PIO mode accesses in todays PDAs.

For CF IDE you might as well drop the IDE layer too and write a small
custom CF-IDE driver if you are doing heavily embedded stuff. 

