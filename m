From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: [RFR] a new SCSI driver
Date: Sun, 25 May 2003 12:48:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030525124836.A31489@flint.arm.linux.org.uk>
References: <200305251119.h4PBJOal000678@81-2-122-30.bradfords.org.uk> <1053859525.1571.0.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:30988 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S261985AbTEYLf3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 May 2003 07:35:29 -0400
Content-Disposition: inline
In-Reply-To: <1053859525.1571.0.camel@laptop.fenrus.com>; from arjanv@redhat.com on Sun, May 25, 2003 at 12:45:25PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: john@grabjohn.com, jgarzik@pobox.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, May 25, 2003 at 12:45:25PM +0200, Arjan van de Ven wrote:
> On Sun, 2003-05-25 at 13:19, john@grabjohn.com wrote:
> > Also embedded world != PDAs.  I was thinking more of things like PVRs, and blade
> > servers.  What about solid state video cameras?  Are they going to use PIO mode
> > ATA?
> on common misunderstanding ; PATA != PIO mode ATA but Parallel ATA, as
> opposed to Serial ATA

I was aware of that point.  That's why I used the term "PIO mode ATA" to
describe something which isn't "PATA".

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

