From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] first batch of shost sysfs fixes
Date: 08 May 2003 09:48:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052401688.2013.25.camel@mulgrave>
References: <20030507150329.D10284@lst.de>
	<20030507140900.GB1727@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:39175 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261428AbTEHNfp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 May 2003 09:35:45 -0400
In-Reply-To: <20030507140900.GB1727@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2003-05-07 at 10:09, Mike Anderson wrote:
> Christoph Hellwig [hch@lst.de] wrote:
> > BTW, Mike, did I miss something or will your changes make every driver
> > converted to scsi_add_host & co OOPS on removal now?  
> > 
> 
> Yes (this is my bad in scsi_host_release), except for scsi_debug. I
> think I should come up with a solution that will not cause changing the
> ~20 callers (at least for this change).
> 
> Post you mail the other day I was reworking the whole patch to correct this and
> align somewhat with you previous mail. I am reworking the patch against
> the merged scsi-misc-2.5.

So could you two get this fixed soon?  I can't push the tree without the
fix (although I could revert the sysfs class changes).  It would also be
nice then to have documentation explaining to driver writers exactly how
they were supposed to be using this mechanism (as a diff to the
scsi_mid_low_api.txt)

James


