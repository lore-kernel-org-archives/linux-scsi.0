From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] kill of ->command
Date: Mon, 9 Jun 2003 15:05:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609190511.GC20308@gtf.org>
References: <20030609162056.GA1857@lst.de> <20030609113247.B5618@one-eyed-alien.net> <20030609183715.GB20308@gtf.org> <20030609114515.D5618@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-64-213-145-173.atlantasolutions.com ([64.213.145.173]:62889
	"EHLO havoc.gtf.org") by vger.kernel.org with ESMTP id S264393AbTFISvb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jun 2003 14:51:31 -0400
Content-Disposition: inline
In-Reply-To: <20030609114515.D5618@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Jun 09, 2003 at 11:45:15AM -0700, Matthew Dharm wrote:
> I've just been bitten on the ass by lack of specific initialization before,
> so I'm overly careful.

Linux encourages lack of specific initialization.  It's an important
feature in several areas, so that is what we prefer.


> BTW, is NULL == (void*)0 everywhere?  I seem to recall places where it
> isn't....

Yes, NULL==0.

	Jeff



