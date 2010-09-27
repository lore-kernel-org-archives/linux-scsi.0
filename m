From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] sd: Fix overflow with big physical blocks
Date: Mon, 27 Sep 2010 13:42:23 -0400
Message-ID: <20100927174223.GB14180@redhat.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>
 <1285605664-27027-3-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab0I0Rm2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 13:42:28 -0400
Content-Disposition: inline
In-Reply-To: <1285605664-27027-3-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

On Mon, Sep 27 2010 at 12:41pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> The hw_sector_size variable could overflow if a device reported huge
> physical blocks.  Switch to the more accurate physical_block_size
> terminology and make sure we use an unsigned int to match the range
> permitted by READ CAPACITY(16).
> 
> Also print a warning of the physical block size exceeds the page size.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>

(with the understanding that we may/will look to limit
physical_block_size to PAGE_SIZE in a follow-on patch).
