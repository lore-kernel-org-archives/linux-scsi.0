From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] kill of ->command
Date: Mon, 9 Jun 2003 14:37:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609183715.GB20308@gtf.org>
References: <20030609162056.GA1857@lst.de> <20030609113247.B5618@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-64-213-145-173.atlantasolutions.com ([64.213.145.173]:20393
	"EHLO havoc.gtf.org") by vger.kernel.org with ESMTP id S264202AbTFISXi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2003 14:23:38 -0400
Content-Disposition: inline
In-Reply-To: <20030609113247.B5618@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Jun 09, 2003 at 11:32:47AM -0700, Matthew Dharm wrote:
> Could you please not kill all these fields?  If you want to remove command,
> go ahead, but leave the others.

What's wrong with the patch?

It's just killing explicit zero-inits...

	Jeff



