From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Tue, 28 Sep 2010 14:54:57 -0400
Message-ID: <20100928185457.GA13438@redhat.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
 <4CA0CC38.5010804@fusionio.com>
 <20100927172309.GA13874@redhat.com>
 <1285624684.2888.120.camel@mulgrave.site>
 <4CA114A3.4010202@fusionio.com>
 <yq1hbhadear.fsf@sermon.lab.mkp.net>
 <4CA1198A.2050004@fusionio.com>
 <yq1wrq5aels.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757145Ab0I1SzH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2010 14:55:07 -0400
Content-Disposition: inline
In-Reply-To: <yq1wrq5aels.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Sep 28 2010 at  2:48pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:
> 
> Jens> With the revised understanding that this is purely the IO hint,
> Jens> then yes I agree we should not clamp it.
> 
> Ok, here's an updated sd patch that does not print a warning...
> 
> 
> sd: Fix overflow with big physical blocks
> 
> The hw_sector_size variable could overflow if a device reported huge
> physical blocks.  Switch to the more accurate physical_block_size
> terminology and make sure we use an unsigned int to match the range
> permitted by READ CAPACITY(16).
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>

Thanks Martin.
