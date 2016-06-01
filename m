From: Andrew Patterson <andrew.patterson@hpe.com>
Subject: Re: [PATCH] sd: Fix rw_max for devices that report an optimal xfer
 size
Date: Wed, 1 Jun 2016 15:57:02 -0600
Message-ID: <574F5A2E.9010000@hpe.com>
References: <1463714194-14258-1-git-send-email-martin.petersen@oracle.com>
 <20160601075222.GA3438@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hpe.com ([15.241.32.99]:18919 "EHLO
	g9t1613g.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbcFAWFZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2016 18:05:25 -0400
In-Reply-To: <20160601075222.GA3438@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org

On 06/01/2016 01:52 AM, Christoph Hellwig wrote:
> Looks fine,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

I tested this patch on a 3Par array (32K optimal transfer length) that has
issues without this patch. After applying this patch on a linux-stable
kernel, optimal_io_size is correctly reported as 32K.

Tested-by: Andrew Patterson <andrew.patterson@hpe.com>

-- 
Andrew Patterson
Hewlett-Packard Enterprise
