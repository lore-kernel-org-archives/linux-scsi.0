From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] first batch of shost sysfs fixes
Date: Wed, 7 May 2003 07:09:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030507140900.GB1727@beaverton.ibm.com>
References: <20030507150329.D10284@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:30371 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S263997AbTEGPBN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2003 11:01:13 -0400
Content-Disposition: inline
In-Reply-To: <20030507150329.D10284@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig [hch@lst.de] wrote:
> BTW, Mike, did I miss something or will your changes make every driver
> converted to scsi_add_host & co OOPS on removal now?  
> 

Yes (this is my bad in scsi_host_release), except for scsi_debug. I
think I should come up with a solution that will not cause changing the
~20 callers (at least for this change).

Post you mail the other day I was reworking the whole patch to correct this and
align somewhat with you previous mail. I am reworking the patch against
the merged scsi-misc-2.5.

-andmike
--
Michael Anderson
andmike@us.ibm.com

