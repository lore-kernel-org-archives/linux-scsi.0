From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] kill of ->command
Date: Mon, 9 Jun 2003 19:22:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609192247.B2006@flint.arm.linux.org.uk>
References: <20030609162056.GA1857@lst.de> <20030609094130.A14870@beaverton.ibm.com> <20030609165157.GA2079@lst.de> <20030609191552.A2006@flint.arm.linux.org.uk> <1055182761.1726.84.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:13839 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S263163AbTFISJN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2003 14:09:13 -0400
Content-Disposition: inline
In-Reply-To: <1055182761.1726.84.camel@mulgrave>; from James.Bottomley@steeleye.com on Mon, Jun 09, 2003 at 01:19:20PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jun 09, 2003 at 01:19:20PM -0500, James Bottomley wrote:
> On Mon, 2003-06-09 at 13:15, Russell King wrote:
> > I'd need to look at the code, but I'd imagine we could probably do
> > everything we need to inside ->queuecommand that's currently being
> > done by ->command.  My only concern would be calling the done
> > function from within queuecommand.
> 
> Calling done from queuecommand() is perfectly legal, as long as you
> return 0 from queuecommand.

In which case I don't see why we can't convert this driver to use just
queuecommand().

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

