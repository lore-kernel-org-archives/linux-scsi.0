From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] SCSI: Add a blacklist flag which enables VPD page
 inquiries
Date: Fri, 18 Jul 2014 15:06:29 +0000
Message-ID: <bd8fd9ebf767494cae023465323622f8@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <yq18unuwos2.fsf@sermon.lab.mkp.net>
 <20140718150406.GA29709@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [207.46.163.145] ([207.46.163.145]:18527 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758671AbaGRPIZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jul 2014 11:08:25 -0400
In-Reply-To: <20140718150406.GA29709@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, July 18, 2014 8:04 AM
> To: Martin K. Petersen
> Cc: linux-scsi@vger.kernel.org; KY Srinivasan
> Subject: Re: [PATCH] SCSI: Add a blacklist flag which enables VPD page
> inquiries
> 
> On Tue, Jul 15, 2014 at 12:49:17PM -0400, Martin K. Petersen wrote:
> >
> > Despite supporting modern SCSI features some storage devices continue
> > to claim conformance to an older version of the SPC spec. This is done
> > for compatibility with legacy operating systems.
> >
> > Linux by default will not attempt to read VPD pages on devices that
> > claim SPC-2 or older. Introduce a blacklist flag that can be used to
> > trigger VPD page inquiries on devices that are known to support them.
> >
> > Reported-by: KY Srinivasan <kys@microsoft.com>
> > Tested-by: KY Srinivasan <kys@microsoft.com>
> > Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> > CC: <stable@vger.kernel.org>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> KY, can you send a hyperv patch that sets it to go along with this one?
Will do. Thanks Christoph.

K. Y
