From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V3 01/16] scsi: support well known logical units
Date: Wed, 10 Sep 2014 11:58:39 -0700
Message-ID: <20140910185839.GA26364@infradead.org>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
 <1410350063-23267-2-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42642 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaIJS6k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 14:58:40 -0400
Content-Disposition: inline
In-Reply-To: <1410350063-23267-2-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Wed, Sep 10, 2014 at 02:54:08PM +0300, Dolev Raviv wrote:
> From: Subhash Jadavani <subhashj@codeaurora.org>
> 
> REPORT LUNS command has "SELECT REPORT" field which controls what type of
> logical units to be reported by device server. According to UFS device
> standard, if this field is set to 0, REPORT LUNS would report only report
> standard logical units. If it's set to 1 then it would report only well
> known logical unit and if it's set to 2 then device would report both
> standard and well known logical units.

This is the defintion of the field in SPC (does the UFS spec duplicate
all of SPC?), but still doesn't explain why you want it.

Also the SELECT REPORT field only appeared in SPC-3, so we should not
set it for devices that report older standards compliance.

