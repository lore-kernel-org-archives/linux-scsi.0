From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] kill of ->command
Date: 09 Jun 2003 13:19:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1055182761.1726.84.camel@mulgrave>
References: <20030609162056.GA1857@lst.de>
	<20030609094130.A14870@beaverton.ibm.com> <20030609165157.GA2079@lst.de>
	<20030609191552.A2006@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:57863 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261624AbTFISGF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2003 14:06:05 -0400
In-Reply-To: <20030609191552.A2006@flint.arm.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-06-09 at 13:15, Russell King wrote:
> I'd need to look at the code, but I'd imagine we could probably do
> everything we need to inside ->queuecommand that's currently being
> done by ->command.  My only concern would be calling the done
> function from within queuecommand.

Calling done from queuecommand() is perfectly legal, as long as you
return 0 from queuecommand.

James


