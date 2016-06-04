From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH] sd: Fix rw_max for devices that report an optimal xfer
 size
Date: Sat, 4 Jun 2016 01:11:46 +0000
Message-ID: <SN1PR0301MB19836DA7C6E4BD94DE776B52CE5A0@SN1PR0301MB1983.namprd03.prod.outlook.com>
References: <1463714194-14258-1-git-send-email-martin.petersen@oracle.com>
 <20160601075222.GA3438@infradead.org> <574F5A2E.9010000@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0111.outbound.protection.outlook.com ([157.56.110.111]:11184
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750727AbcFDBLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2016 21:11:50 -0400
In-Reply-To: <574F5A2E.9010000@hpe.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hpe.com>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>

It tested well with hyper-v virtual disk.

Tested-by: Long Li <longli@microsoft.com>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Andrew Patterson
> Sent: Wednesday, June 1, 2016 2:57 PM
> To: Christoph Hellwig <hch@infradead.org>; Martin K. Petersen
> <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH] sd: Fix rw_max for devices that report an optimal xfer
> size
> 
> On 06/01/2016 01:52 AM, Christoph Hellwig wrote:
> > Looks fine,
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> > in the body of a message to majordomo@vger.kernel.org More
> majordomo
> > info at
> > https://na01.safelinks.protection.outlook.com/?url=http%3a%2f%2fvger.k
> > ernel.org%2fmajordomo-
> info.html&data=01%7c01%7clongli%40microsoft.com%
> >
> 7c424f9a9645da456fa38d08d38a68db13%7c72f988bf86f141af91ab2d7cd011db
> 47%
> > 7c1&sdata=cojfwxQ8%2bZLpkiT5mFlsclG6DDLBWPk8qNAg3crPtIc%3d
> >
> 
> I tested this patch on a 3Par array (32K optimal transfer length) that has
> issues without this patch. After applying this patch on a linux-stable kernel,
> optimal_io_size is correctly reported as 32K.
> 
> Tested-by: Andrew Patterson <andrew.patterson@hpe.com>
> 
> --
> Andrew Patterson
> Hewlett-Packard Enterprise
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> https://na01.safelinks.protection.outlook.com/?url=http%3a%2f%2fvger.ker
> nel.org%2fmajordomo-
> info.html&data=01%7c01%7clongli%40microsoft.com%7c424f9a9645da456fa3
> 8d08d38a68db13%7c72f988bf86f141af91ab2d7cd011db47%7c1&sdata=cojfwx
> Q8%2bZLpkiT5mFlsclG6DDLBWPk8qNAg3crPtIc%3d
