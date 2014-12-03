From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 00/12] nobody loves the advansys driver
Date: Wed, 03 Dec 2014 11:06:58 -0500
Message-ID: <547F3522.4070205@interlog.com>
References: <1417607105-85455-1-git-send-email-hare@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:53506 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaLCQHR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 11:07:17 -0500
In-Reply-To: <1417607105-85455-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On 14-12-03 06:44 AM, Hannes Reinecke wrote:
> Hi all,
>
> it has been bugged me for ages that the advansys driver always
> reported a compilation warning about not having been converted
> to the DMA-API.
> And even aggressive waiting hasn't made this warning go away.
>
> So here's a patchset to update the advansys driver to current
> standards and use the DMA-API.
> Tested on ABP940-U2W.
>
> As usual, reviews and comments are welcome.
>
> Hannes Reinecke (12):
>    advansys: use host_reset
>    advansys: use shared host tag map for command lookup
>    advansys: use DMA-API for mapping sense buffer
>    advansys: Use DMA-API for carrier buffer
>    advansys: Use DMA-API for mapping request blocks
>    advansys: Use dma_pool for sg elements
>    advansys: use 'bool' instead of 'int'
>    advansys: use standard data types
>    advansys: Remove 'TRUE' and 'FALSE' definitions
>    advansys: Remove 'ERR' definition
>    advansys: cleanup function return codes
>    advansys: Update to version 3.5 and remove compilation warning
>
>   MAINTAINERS             |    1 +
>   drivers/scsi/advansys.c | 1073 +++++++++++++++++++++--------------------------
>   2 files changed, 469 insertions(+), 605 deletions(-)

Looks good.

Tried to find my old Advansys HBAs but failed, probably
the result of a purge a few years back. Hence I was unable
to test it with my few remaining SPI disks and tape drive.
If memory serves, for a while Advansys HBAs were bundled
with SCSI scanners.

The original Advansys maintainer, Bob Frey, I suspect was
the recipient of my first SCSI related queries.


Reviewed-by: Douglas Gilbert <dgilbert@interlog.com>

